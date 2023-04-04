{ pname
, version
, patches
, dart
, src
, mkFlutter
, usePreload
}:
{ bash
, buildFHSUserEnv
, cacert
, git
, curl
, unzip
, xz
, runCommand
, stdenv
, lib
, alsa-lib
, dbus
, expat
, libpulseaudio
, libuuid
, libX11
, libxcb
, libXcomposite
, libXcursor
, libXdamage
, libXfixes
, libXrender
, libXtst
, libXi
, libXext
, libGL
, nspr
, nss
, systemd
, which
, callPackage
, autoPatchelfHook
, gtk3
, atk
, glib
, libepoxy
,
}:
let
  drvName = "${pname}-${version}";
  flutter-unwrapped = stdenv.mkDerivation {
    name = "${pname}-unwrapped";

    buildInputs = [
      dart
      gtk3
      atk
      glib
      libepoxy
    ];

    inherit src patches version;

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

      ${if usePreload then ''

      # we need to make the home $out here because dart pub get and pub cache preload will, place dependencies, which
      # may also be required later at runtime of the flutter command, in $HOME/.pub-cache
      mkdir -p $out
      HOME=$out

      dart pub cache preload .pub-preload-cache/* || (echo "dart pub cache preload failed. If you are overriding flutter's sources to build an older version, set usePreload to false in mkFlutter (preload is needed for dart >= 2.19 and flutter >= 3.7.9)" && exit 1)'' else ''
      HOME=../..
      ''}

      pushd "$FLUTTER_TOOLS_DIR"
        rm -rf test
        dart pub get --offline -v
      popd

      local revision="$(cd "$FLUTTER_ROOT"; git rev-parse HEAD)"
      dart --snapshot="$SNAPSHOT_PATH" --packages="$FLUTTER_TOOLS_DIR/.dart_tool/package_config.json" "$SCRIPT_PATH"
      echo "$revision" > "$STAMP_PATH"
      echo -n "${version}" > version

      rm -r bin/cache/dart-sdk
    '';

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    installPhase = ''
      runHook preInstall

      cp -r . $out
      mkdir -p $out/bin/cache/
      ln -sf ${dart} $out/bin/cache/dart-sdk

      runHook postInstall
    '';

    postFixup = ''
      # flutter is really senstive about the executable being called flutter and being in the
      # bin folder, so this is easier than creating another bin directory somewhere and mkWrapper-ing.

      sed -i '2i\
      export PUB_CACHE=\''${PUB_CACHE:-"\$HOME/.pub-cache"}\
      export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1\
      export PATH=$PATH:${lib.makeBinPath [
        bash
        curl
        dart
        git
        unzip
        which
        xz
      ]}
      ' $out/bin/flutter
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ which git ];
    installCheckPhase = ''
      runHook preInstallCheck

      export HOME="$(mktemp -d)"
      $out/bin/flutter config --android-studio-dir $HOME
      $out/bin/flutter config --android-sdk $HOME
      $out/bin/flutter --version | fgrep -q '${version}'

      runHook postInstallCheck
    '';

  };

  # Flutter only use these certificates
  cert = runCommand "fedoracert" { } ''
    mkdir -p $out/etc/pki/tls/
    ln -s ${cacert}/etc/ssl/certs $out/etc/pki/tls/certs
  '';

  # Wrap flutter inside an fhs user env to allow execution of binary,
  # like adb from $ANDROID_HOME or java from android-studio.
  fhsEnv = buildFHSUserEnv {
    name = "${drvName}-fhs-env";
    multiPkgs = pkgs: [
      cert
      pkgs.zlib
    ];
    targetPkgs = pkgs:
      with pkgs; [
        bash
        curl
        dart
        git
        unzip
        which
        xz
        cmake
        ninja
        pkg-config
        gtk3

        # flutter test requires this lib
        libGLU

        # for android emulator
        alsa-lib
        dbus
        expat
        libpulseaudio
        libuuid
        libX11
        libxcb
        libXcomposite
        libXcursor
        libXdamage
        libXext
        libXfixes
        libXi
        libXrender
        libXtst
        libGL
        glib
        nspr
        nss
        systemd
      ];
  };

  makeFhsWrapper =
    { executable ? "flutter"
    , newExecutableName ? executable
    , derv ? flutter-unwrapped
    , extraRunCommandArgs
    } : runCommand "${drvName}-fhs"
      ({
        startScript = ''
          #!${bash}/bin/bash
          ${fhsEnv}/bin/${drvName}-fhs-env ${derv}/bin/${executable} --no-version-check "$@"
        '';
        preferLocalBuild = true;
        allowSubstitutes = false;
      } // extraRunCommandArgs) ''

      mkdir -p $out/bin/cache/
      ln -sf ${dart} $out/bin/cache/dart-sdk
      ln -sf ${dart}/bin/dart $out/bin
      echo -n "$startScript" > $out/bin/${newExecutableName}
      chmod +x $out/bin/${newExecutableName}
    '';
  flutter = makeFhsWrapper {
    extraRunCommandArgs.passthru = {
      unwrapped = flutter-unwrapped;
      inherit dart mkFlutter makeFhsWrapper;
      mkFlutterApp = callPackage ../../../build-support/flutter { inherit flutter; };
      tests = {
        runFlutterDoctor = runCommand "${drvName}-test-runFlutterDoctor" {
          nativeBuildInputs = [ flutter ];
        } ''
        # we don't care about the output, just that it does not fail
        flutter doctor -vv
        echo $? > $out
        '';
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
        maintainers = with maintainers; [ babariviere ericdallo h7x4 gilice FlafyDev ];
      };
    };
  };
in
flutter
