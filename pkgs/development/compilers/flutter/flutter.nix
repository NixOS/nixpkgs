{ version
, engineVersion
, patches
, dart
, src
, includedEngineArtifacts ? {
    common = [
      "flutter_patched_sdk"
      "flutter_patched_sdk_product"
    ];
    platform = {
      android = lib.optionalAttrs stdenv.hostPlatform.isx86_64
        ((lib.genAttrs [ "arm" "arm64" "x64" ] (architecture: [ "profile" "release" ])) // { x86 = [ "jit-release" ]; });
      linux = lib.optionals stdenv.hostPlatform.isLinux
        (lib.genAttrs ((lib.optional stdenv.hostPlatform.isx86_64 "x64") ++ (lib.optional stdenv.hostPlatform.isAarch64 "arm64"))
          (architecture: [ "debug" "profile" "release" ]));
    };
  }

, lib
, callPackage
, stdenv
, runCommandLocal
, symlinkJoin
, lndir
, git
, which
}:

let
  engineArtifactDirectory =
    let
      engineArtifacts = callPackage ./engine-artifacts { inherit engineVersion; };
    in
    runCommandLocal "flutter-engine-artifacts-${version}" { }
      (
        let
          mkCommonArtifactLinkCommand = { artifact }:
            ''
              mkdir -p $out/common
              ${lndir}/bin/lndir -silent ${artifact} $out/common
            '';
          mkPlatformArtifactLinkCommand = { artifact, os, architecture, variant ? null }:
            let
              artifactDirectory = "${os}-${architecture}${lib.optionalString (variant != null) "-${variant}"}";
            in
            ''
              mkdir -p $out/${artifactDirectory}
                ${lndir}/bin/lndir -silent ${artifact} $out/${artifactDirectory}
            '';
        in
        ''
          ${
            builtins.concatStringsSep "\n"
              ((map (name: mkCommonArtifactLinkCommand {
                artifact = engineArtifacts.common.${name};
              }) (if includedEngineArtifacts ? common then includedEngineArtifacts.common else [ ])) ++
              (builtins.foldl' (commands: os: commands ++
                (builtins.foldl' (commands: architecture: commands ++
                  (builtins.foldl' (commands: variant: commands ++
                    (map (artifact: mkPlatformArtifactLinkCommand {
                      inherit artifact os architecture variant;
                    }) engineArtifacts.platform.${os}.${architecture}.variants.${variant}))
                  (map (artifact: mkPlatformArtifactLinkCommand {
                    inherit artifact os architecture;
                  }) engineArtifacts.platform.${os}.${architecture}.base)
                  includedEngineArtifacts.platform.${os}.${architecture}))
                [] (builtins.attrNames includedEngineArtifacts.platform.${os})))
              [] (builtins.attrNames (if includedEngineArtifacts ? platform then includedEngineArtifacts.platform else { }))))
          }
        ''
      );

  unwrapped =
    stdenv.mkDerivation {
      name = "flutter-${version}-unwrapped";
      inherit src patches version;

      outputs = [ "out" "cache" ];

      buildInputs = [ git ];

      preConfigure = ''
        if [ "$(< bin/internal/engine.version)" != '${engineVersion}' ]; then
          echo 1>&2 "The given engine version (${engineVersion}) does not match the version required by the Flutter SDK ($(< bin/internal/engine.version))."
          exit 1
        fi
      '';

      postPatch = ''
        patchShebangs --build ./bin/
      '';

      buildPhase = ''
        export FLUTTER_ROOT="$(pwd)"
        export FLUTTER_TOOLS_DIR="$FLUTTER_ROOT/packages/flutter_tools"
        export SCRIPT_PATH="$FLUTTER_TOOLS_DIR/bin/flutter_tools.dart"

        export SNAPSHOT_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot"
        export STAMP_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.stamp"

        export DART_SDK_PATH="${dart}"

        # The Flutter tool compilation requires dependencies to be cached, as there is no Internet access.
        # Dart expects package caches to be mutable, and does not support composing cache directories.
        # The packages cached during the build therefore cannot be easily used. They are provided through
        # the derivation's "cache" output, though, in case they are needed.
        #
        # Note that non-cached packages will normally be fetched from the Internet when they are needed, so Flutter
        # will function without an existing package cache as long as it has an Internet connection.
        export PUB_CACHE="$cache"

        if [ -d .pub-preload-cache ]; then
          ${dart}/bin/dart pub cache preload .pub-preload-cache/*
        elif [ -d .pub-cache ]; then
          mv .pub-cache "$PUB_CACHE"
        else
          echo 'ERROR: Failed to locate the Dart package cache required to build the Flutter tool.'
          exit 1
        fi

        pushd "$FLUTTER_TOOLS_DIR"
        ${dart}/bin/dart pub get --offline
        popd

        local revision="$(cd "$FLUTTER_ROOT"; git rev-parse HEAD)"
        ${dart}/bin/dart --snapshot="$SNAPSHOT_PATH" --packages="$FLUTTER_TOOLS_DIR/.dart_tool/package_config.json" "$SCRIPT_PATH"
        echo "$revision" > "$STAMP_PATH"
        echo -n "${version}" > version

        # Certain prebuilts should be replaced with Nix-built (or at least Nix-patched) equivalents.
        rm -r \
          bin/cache/dart-sdk \
          bin/cache/artifacts/engine
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r . $out
        ln -sf ${dart} $out/bin/cache/dart-sdk
        ln -sf ${engineArtifactDirectory} $out/bin/cache/artifacts/engine

        runHook postInstall
      '';

      doInstallCheck = true;
      nativeInstallCheckInputs = [ which ];
      installCheckPhase = ''
        runHook preInstallCheck

        export HOME="$(mktemp -d)"
        $out/bin/flutter config --android-studio-dir $HOME
        $out/bin/flutter config --android-sdk $HOME
        $out/bin/flutter --version | fgrep -q '${version}'

        runHook postInstallCheck
      '';

      passthru = {
        inherit dart;
        # The derivation containing the original Flutter SDK files.
        # When other derivations wrap this one, any unmodified files
        # found here should be included as-is, for tooling compatibility.
        sdk = unwrapped;
      };

      meta = with lib; {
        description = "Flutter is Google's SDK for building mobile, web and desktop with Dart";
        longDescription = ''
          Flutter is Google’s UI toolkit for building beautiful,
          natively compiled applications for mobile, web, and desktop from a single codebase.
        '';
        homepage = "https://flutter.dev";
        license = licenses.bsd3;
        platforms = [ "x86_64-linux" "aarch64-linux" ];
        maintainers = with maintainers; [ babariviere ericdallo FlafyDev gilice hacker1024 ];
      };
    };
in
unwrapped
