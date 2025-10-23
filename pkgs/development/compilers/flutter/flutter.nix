{
  useNixpkgsEngine ? false,
  version,
  engineVersion,
  engineHashes ? { },
  engineUrl ?
    if lib.versionAtLeast version "3.29" then
      "https://github.com/flutter/flutter.git@${engineVersion}"
    else
      "https://github.com/flutter/engine.git@${engineVersion}",
  enginePatches ? [ ],
  engineRuntimeModes ? [
    "release"
    "debug"
  ],
  engineSwiftShaderHash,
  engineSwiftShaderRev,
  patches,
  channel,
  dart,
  src,
  pubspecLock,
  artifactHashes ? null,
  lib,
  stdenv,
  callPackage,
  makeWrapper,
  darwin,
  gitMinimal,
  which,
  jq,
  flutterTools ? null,
}@args:

let
  engine =
    if args.useNixpkgsEngine or false then
      callPackage ./engine/default.nix {
        inherit (args) dart;
        dartSdkVersion = args.dart.version;
        flutterVersion = version;
        swiftshaderRev = engineSwiftShaderRev;
        swiftshaderHash = engineSwiftShaderHash;
        version = engineVersion;
        hashes = engineHashes;
        url = engineUrl;
        patches = enginePatches;
        runtimeModes = engineRuntimeModes;
      }
    else
      null;

  dart = if args.useNixpkgsEngine or false then engine.dart else args.dart;

  flutterTools =
    args.flutterTools or (callPackage ./flutter-tools.nix {
      inherit
        dart
        engineVersion
        patches
        pubspecLock
        version
        ;
      flutterSrc = src;
      systemPlatform = stdenv.hostPlatform.system;
    });

  unwrapped = stdenv.mkDerivation {
    name = "flutter-${version}-unwrapped";
    inherit src patches version;

    nativeBuildInputs = [
      makeWrapper
      jq
      gitMinimal
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];
    strictDeps = true;

    preConfigure = ''
      if [ "$(< bin/internal/engine.version)" != '${engineVersion}' ]; then
        echo 1>&2 "The given engine version (${engineVersion}) does not match the version required by the Flutter SDK ($(< bin/internal/engine.version))."
        exit 1
      fi
    '';

    postPatch = ''
      patchShebangs --build ./bin/
      patchShebangs packages/flutter_tools/bin
    '';

    buildPhase = ''
      # The flutter_tools package tries to run many Git commands. In most
      # cases, unexpected output is handled gracefully, but commands are never
      # expected to fail completely. A blank repository needs to be created.
      rm -rf .git # Remove any existing Git directory
      git init -b nixpkgs
      GIT_AUTHOR_NAME=Nixpkgs GIT_COMMITTER_NAME=Nixpkgs \
      GIT_AUTHOR_EMAIL= GIT_COMMITTER_EMAIL= \
      GIT_AUTHOR_DATE='1/1/1970 00:00:00 +0000' GIT_COMMITTER_DATE='1/1/1970 00:00:00 +0000' \
        git commit --allow-empty -m "Initial commit"
      (. '${../../../build-support/fetchgit/deterministic-git}'; make_deterministic_repo .)

      mkdir -p bin/cache

      # Add a flutter_tools artifact stamp, and build a snapshot.
      # This is the Flutter CLI application.
      echo "$(git rev-parse HEAD)" > bin/cache/flutter_tools.stamp
      ln -s '${flutterTools}/share/flutter_tools.snapshot' bin/cache/flutter_tools.snapshot

      # Some of flutter_tools's dependencies contain static assets. The
      # application attempts to read its own package_config.json to find these
      # assets at runtime.
      mkdir -p packages/flutter_tools/.dart_tool
      ln -s '${flutterTools.pubcache}/package_config.json' packages/flutter_tools/.dart_tool/package_config.json

      echo -n "${version}" > version
      cat <<EOF > bin/cache/flutter.version.json
      {
        "devToolsVersion": "$(cat "${dart}/bin/resources/devtools/version.json" | jq -r .version)",
        "flutterVersion": "${version}",
        "frameworkVersion": "${version}",
        "channel": "${channel}",
        "repositoryUrl": "https://github.com/flutter/flutter.git",
        "frameworkRevision": "nixpkgs000000000000000000000000000000000",
        "frameworkCommitDate": "1970-01-01 00:00:00",
        "engineRevision": "${engineVersion}",
        "dartSdkVersion": "${dart.version}"
      }
      EOF

      # Suppress a small error now that `.gradle`'s location changed.
      # Location changed because of the patch "gradle-flutter-tools-wrapper.patch".
      mkdir -p "$out/packages/flutter_tools/gradle/.gradle"
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out
      rm -rf $out/bin/cache/dart-sdk
      ln -sf ${dart} $out/bin/cache/dart-sdk

      # The regular launchers are designed to download/build/update SDK
      # components, and are not very useful in Nix.
      # Replace them with simple links and wrappers.
      rm "$out/bin"/{dart,flutter}
      ln -s "$out/bin/cache/dart-sdk/bin/dart" "$out/bin/dart"
      makeShellWrapper "$out/bin/dart" "$out/bin/flutter" \
        --set-default FLUTTER_ROOT "$out" \
        --set FLUTTER_ALREADY_LOCKED true \
        --add-flags "--disable-dart-dev --packages='${flutterTools.pubcache}/package_config.json' \$NIX_FLUTTER_TOOLS_VM_OPTIONS $out/bin/cache/flutter_tools.snapshot"

      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [
      which
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];
    installCheckPhase = ''
      runHook preInstallCheck

      export HOME="$(mktemp -d)"
      $out/bin/flutter config --android-studio-dir $HOME
      $out/bin/flutter config --android-sdk $HOME
      $out/bin/flutter --version | fgrep -q '${builtins.substring 0 10 engineVersion}'

      runHook postInstallCheck
    '';

    passthru = {
      # TODO: rely on engine.version instead of engineVersion
      inherit
        dart
        engineVersion
        artifactHashes
        channel
        ;
      tools = flutterTools;
      # The derivation containing the original Flutter SDK files.
      # When other derivations wrap this one, any unmodified files
      # found here should be included as-is, for tooling compatibility.
      sdk = unwrapped;
    }
    // lib.optionalAttrs (engine != null) {
      inherit engine;
    };

    meta = {
      broken = (lib.versionOlder version "3.32") && useNixpkgsEngine;
      description = "Makes it easy and fast to build beautiful apps for mobile and beyond";
      longDescription = ''
        Flutter is Google's SDK for crafting beautiful,
        fast user experiences for mobile, web, and desktop from a single codebase.
      '';
      homepage = "https://flutter.dev";
      license = lib.licenses.bsd3;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      mainProgram = "flutter";
      maintainers = with lib.maintainers; [
        ericdallo
      ];
      teams = [ lib.teams.flutter ];
    };
  };
in
unwrapped
