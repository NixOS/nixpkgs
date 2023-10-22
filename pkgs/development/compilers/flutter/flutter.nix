{ version
, engineVersion
, patches
, dart
, src
, pubspecLockFile
, vendorHash
, depsListFile
, lib
, stdenv
, callPackage
, darwin
, git
, which
}:

let
  tools = callPackage ./flutter-tools.nix {
    inherit dart version;
    flutterSrc = src;
    inherit patches;
    inherit pubspecLockFile vendorHash depsListFile;
  };

  unwrapped =
    stdenv.mkDerivation {
      name = "flutter-${version}-unwrapped";
      inherit src patches version;

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

        mkdir -p "$FLUTTER_ROOT/bin/cache"
        export SNAPSHOT_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot"
        export STAMP_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.stamp"

        local revision="$(cd "$FLUTTER_ROOT"; git rev-parse HEAD)"
        echo "$revision" > "$STAMP_PATH"
        ln -s '${tools}/share/flutter_tools.snapshot' "$SNAPSHOT_PATH"
        echo -n "${version}" > version
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
        inherit dart engineVersion tools;
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
