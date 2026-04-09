{
  scope,
  lib,
  stdenv,
  dart,
  autoPatchelfHook,
  flutterSource,
  flutter-tools,
  callPackage,
  host-artifacts,
  artifacts ? host-artifacts,
  version,
  engineVersion,
  channel,
  dartVersion,
  patches,
  makeWrapper,
  gitMinimal,
  which,
  jq,
  unzip,
  gnutar,
  pkg-config,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  libepoxy,
  pango,
  libx11,
  xorgproto,
  libdeflate,
  zlib,
  cmake,
  ninja,
  clang,
  darwin,
  cipd,
  depot_tools,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,
  fd,
  cacert,
  moreutils,
  writeTextFile,
  supportedTargetFlutterPlatforms,
  extraPkgConfigPackages ? [ ],
  extraLibraries ? [ ],
  extraIncludes ? [ ],
  extraCxxFlags ? [ ],
  extraCFlags ? [ ],
  extraLinkerFlags ? [ ],
}:

let
  appRuntimeDeps =
    lib.optionals
      (stdenv.hostPlatform.isLinux && (builtins.elem "linux" supportedTargetFlutterPlatforms))
      [
        atk
        cairo
        gdk-pixbuf
        glib
        gtk3
        harfbuzz
        libepoxy
        pango
        libx11
        libdeflate
      ];

  # Development packages required for compilation.
  appBuildDeps =
    let
      # https://discourse.nixos.org/t/handling-transitive-c-dependencies/5942/3
      deps =
        pkg: lib.filter lib.isDerivation ((pkg.buildInputs or [ ]) ++ (pkg.propagatedBuildInputs or [ ]));
      withKey = pkg: {
        key = pkg.outPath;
        val = pkg;
      };
      collect = pkg: lib.map withKey ([ pkg ] ++ deps pkg);
    in
    lib.map (e: e.val) (
      lib.genericClosure {
        startSet = lib.map withKey appRuntimeDeps;
        operator = item: collect item.val;
      }
    );

  appStaticBuildDeps =
    (lib.optionals
      (stdenv.hostPlatform.isLinux && (builtins.elem "linux" supportedTargetFlutterPlatforms))
      [
        libx11
        xorgproto
        zlib
      ]
    )
    ++ extraLibraries;

  # Tools used by the Flutter SDK to compile applications.
  buildTools =
    lib.optionals
      (stdenv.hostPlatform.isLinux && (builtins.elem "linux" supportedTargetFlutterPlatforms))
      [
        pkg-config
        cmake
        ninja
        clang
      ];

  # Nix-specific compiler configuration.
  pkgConfigPackages = map (lib.getOutput "dev") (appBuildDeps ++ extraPkgConfigPackages);

  includeFlags = map (pkg: "-isystem ${lib.getOutput "dev" pkg}/include") (
    appStaticBuildDeps ++ extraIncludes
  );

  linkerFlags =
    (map (pkg: "-rpath,${lib.getOutput "lib" pkg}/lib") appRuntimeDeps) ++ extraLinkerFlags;
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "flutter";
  inherit version patches;

  src = flutterSource;

  nativeBuildInputs = [
    moreutils
    makeWrapper
    jq
    unzip
    gnutar
  ]
  ++
    lib.optionals
      (stdenv.hostPlatform.isLinux && (builtins.elem "linux" supportedTargetFlutterPlatforms))
      [
        wrapGAppsHook3
        autoPatchelfHook
      ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  buildInputs = appRuntimeDeps;

  postPatch = ''
    patchShebangs --build ./bin/
    patchShebangs packages/flutter_tools/bin
  '';

  preConfigure = ''
    if [ "$(< bin/internal/engine.version)" != '${engineVersion}' ]; then
      echo 1>&2 "The given engine version (${engineVersion}) does not match the version required by the Flutter SDK ($(< bin/internal/engine.version))."
      exit 1
    fi
  '';

  buildPhase = ''
    runHook preBuild

    mkdir --parents bin/cache
  ''
  # Add a flutter_tools artifact stamp, and build a snapshot.
  # This is the Flutter CLI application.
  + ''
    echo "nixpkgs000000000000000000000000000000000" > bin/cache/flutter_tools.stamp
    ln --symbolic ${flutter-tools}/share/flutter_tools.snapshot bin/cache/flutter_tools.snapshot
  ''
  # Some of flutter_tools's dependencies contain static assets. The
  # application attempts to read its own package_config.json to find these
  # assets at runtime.
  + ''
    mkdir --parents packages/flutter_tools/.dart_tool
    ln --symbolic ${flutter-tools.pubcache}/package_config.json packages/flutter_tools/.dart_tool/package_config.json
  ''
  + lib.optionalString (lib.versionOlder version "3.33") ''
    echo -n "${version}" > version
  ''
  + ''
    cp ${
      writeTextFile {
        name = "flutter.version.json";
        text = builtins.toJSON {
          flutterVersion = version;
          frameworkVersion = version;
          channel = channel;
          repositoryUrl = "https://github.com/flutter/flutter.git";
          frameworkRevision = "nixpkgs000000000000000000000000000000000";
          frameworkCommitDate = "1970-01-01 00:00:00";
          engineRevision = engineVersion;
          dartSdkVersion = dartVersion;
        };
      }
    } bin/cache/flutter.version.json
    jq --arg version "$(jq --raw-output .version ${dart}/bin/resources/devtools/version.json)" '. + {devToolsVersion: $version}' bin/cache/flutter.version.json | sponge bin/cache/flutter.version.json
    echo "${engineVersion}" > bin/cache/engine.stamp
  ''
  # Suppress a small error now that `.gradle`'s location changed.
  # Location changed because of the patch "gradle-flutter-tools-wrapper.patch".
  + ''
    mkdir --parents packages/flutter_tools/gradle/.gradle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.concatMapStrings (artifact: ''
      ${lib.optionalString (
        artifact.target == "bin/cache/flutter_web_sdk"
      ) ''rm --recursive --force "$out/${artifact.target}"''}
      ${
        if
          (
            (lib.hasSuffix ".zip" artifact.path)
            || (lib.hasSuffix ".tar.gz" artifact.path)
            || (lib.hasSuffix ".tgz" artifact.path)
          )
        then
          ''
            temp_path=$(mktemp -d)
            ${lib.optionalString (lib.hasSuffix ".zip" artifact.path) ''unzip -o "${artifact.path}" -d "$temp_path"''}
            ${lib.optionalString (
              (lib.hasSuffix ".tar.gz" artifact.path) || (lib.hasSuffix ".tgz" artifact.path)
            ) ''tar --extract --gzip --file "${artifact.path}" --directory "$temp_path"''}
          ''
        else
          ''
            temp_path="${artifact.path}"
          ''
      }
      content_count=$(ls --almost-all "$temp_path" | wc --lines)
      target_path="$out/${artifact.target}"
      if [ "$content_count" -eq 1 ] && [ ! -e "$target_path" ]; then
        mkdir --parents "$(dirname "$target_path")"
        cp --recursive --no-target-directory "$temp_path"/* "$target_path"
      else
        mkdir --parents "$target_path"
        cp --recursive "$temp_path"/* "$target_path"/
      fi
      chmod --recursive +w "$target_path"
      if [ "${artifact.path}" != "$temp_path" ]; then
        rm --recursive --force "$temp_path"
      fi
    '') artifacts}

    cp --recursive . $out
    ln --symbolic --force ${dart} $out/bin/cache/dart-sdk
  ''
  # The regular launchers are designed to download/build/update SDK
  # components, and are not very useful in Nix.
  # Replace them with simple links and wrappers.
  + ''
    rm $out/bin/{dart,flutter}
    ln --symbolic ${lib.getExe dart} $out/bin/dart

    for path in ${
      builtins.concatStringsSep " " (
        builtins.foldl' (
          paths: pkg:
          paths
          ++ (map (directory: "'${pkg}/${directory}/pkgconfig'") [
            "lib"
            "share"
          ])
        ) [ ] pkgConfigPackages
      )
    }; do
      addToSearchPath FLUTTER_PKG_CONFIG_PATH "$path"
    done

    makeWrapper ${lib.getExe dart} $out/bin/flutter \
      --set-default FLUTTER_ROOT $out \
      --set-default ANDROID_EMULATOR_USE_SYSTEM_LIBS 1 \
      --set FLUTTER_ALREADY_LOCKED true \
      --suffix PATH : '${
        lib.makeBinPath (
          [
            depot_tools
            cipd
            which
          ]
          ++ buildTools
        )
      }' \
      --suffix PKG_CONFIG_PATH : "$FLUTTER_PKG_CONFIG_PATH" \
      --suffix LIBRARY_PATH : '${lib.makeLibraryPath appStaticBuildDeps}' \
      --prefix CXXFLAGS "''\t" '${builtins.concatStringsSep " " (includeFlags ++ extraCxxFlags)}' \
      --prefix CFLAGS "''\t" '${builtins.concatStringsSep " " (includeFlags ++ extraCFlags)}' \
      --prefix LDFLAGS "''\t" '${
        builtins.concatStringsSep " " (map (flag: "-Wl,${flag}") linkerFlags)
      }' \
      ''${gappsWrapperArgs[@]} \
      --add-flags "--disable-dart-dev --packages='${flutter-tools.pubcache}/package_config.json' --root-certs-file='${cacert}/etc/ssl/certs/ca-bundle.crt' $out/bin/cache/flutter_tools.snapshot"

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    which
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/flutter config --android-studio-dir $HOME
    $out/bin/flutter config --android-sdk $HOME
    $out/bin/flutter --version | fgrep --quiet '${builtins.substring 0 10 engineVersion}'

    runHook postInstallCheck
  '';

  dontWrapGApps = true;

  # https://github.com/flutter/engine/pull/28525
  appendRunpaths = lib.optionals (
    stdenv.hostPlatform.isLinux && (builtins.elem "linux" supportedTargetFlutterPlatforms)
  ) [ "$ORIGIN" ];

  passthru = {
    buildFlutterApplication = callPackage ./build-support/build-flutter-application.nix {
      flutter = scope.flutter;
    };
    updateScript = ./update.py;
    inherit scope;
    inherit (scope) dart;
  };

  meta = {
    description = "Makes it easy and fast to build beautiful apps for mobile and beyond";
    longDescription = ''
      Flutter is Google's SDK for crafting beautiful,
      fast user experiences for mobile, web, and desktop from a single codebase.
    '';
    homepage = "https://flutter.dev";
    license = lib.licenses.bsd3;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "flutter";
    maintainers = with lib.maintainers; [ ericdallo ];
    teams = [ lib.teams.flutter ];
  };
})
