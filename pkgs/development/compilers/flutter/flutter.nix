{ version
, engineVersion
, patches
, dart
, src
, lib
, stdenv
, darwin
, git
, which
}:

let
  unwrapped =
    stdenv.mkDerivation {
      name = "flutter-${version}-unwrapped";
      inherit src patches version;

      outputs = [ "out" "cache" ];

      buildInputs = [ git ];
      nativeBuildInputs = [ ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

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
          $FLUTTER_ROOT/bin/cache/dart-sdk \
          $FLUTTER_ROOT/bin/cache/artifacts/engine
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r . $out
        ln -sf ${dart} $out/bin/cache/dart-sdk

        runHook postInstall
      '';

      doInstallCheck = true;
      nativeInstallCheckInputs = [ which ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];
      installCheckPhase = ''
        runHook preInstallCheck

        export HOME="$(mktemp -d)"
        $out/bin/flutter config --android-studio-dir $HOME
        $out/bin/flutter config --android-sdk $HOME
        $out/bin/flutter --version | fgrep -q '${version}'

        runHook postInstallCheck
      '';

      passthru = {
        inherit dart engineVersion;
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
        platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        maintainers = with maintainers; [ babariviere ericdallo FlafyDev hacker1024 ];
      };
    };
in
unwrapped
