{ channel, pname, version, sha256Hash, patches
, filename ? "flutter_linux_v${version}-${channel}.tar.xz" }:

{ bash, buildFHSUserEnv, cacert, coreutils, git, makeWrapper, runCommand, stdenv
, fetchurl, alsaLib, dbus, expat, libpulseaudio, libuuid, libX11, libxcb
, libXcomposite, libXcursor, libXdamage, libXfixes, libGL, nspr, nss, systemd }:

let
  drvName = "flutter-${channel}-${version}";
  flutter = stdenv.mkDerivation {
    name = "${drvName}-unwrapped";

    src = fetchurl {
      url =
        "https://storage.googleapis.com/flutter_infra/releases/${channel}/linux/${filename}";
      sha256 = sha256Hash;
    };

    buildInputs = [ makeWrapper git ];

    inherit patches;

    postPatch = ''
      patchShebangs --build ./bin/
      find ./bin/ -executable -type f -exec patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) {} \;
    '';

    buildPhase = ''
      FLUTTER_ROOT=$(pwd)
      FLUTTER_TOOLS_DIR="$FLUTTER_ROOT/packages/flutter_tools"
      SNAPSHOT_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot"
      STAMP_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.stamp"
      SCRIPT_PATH="$FLUTTER_TOOLS_DIR/bin/flutter_tools.dart"
      DART_SDK_PATH="$FLUTTER_ROOT/bin/cache/dart-sdk"

      DART="$DART_SDK_PATH/bin/dart"
      PUB="$DART_SDK_PATH/bin/pub"

      HOME=../.. # required for pub upgrade --offline, ~/.pub-cache
                 # path is relative otherwise it's replaced by /build/flutter

      (cd "$FLUTTER_TOOLS_DIR" && "$PUB" upgrade --offline)

      local revision="$(cd "$FLUTTER_ROOT"; git rev-parse HEAD)"
      "$DART" --snapshot="$SNAPSHOT_PATH" --packages="$FLUTTER_TOOLS_DIR/.packages" "$SCRIPT_PATH"
      echo "$revision" > "$STAMP_PATH"
      echo -n "${version}" > version

      rm -rf bin/cache/{artifacts,downloads}
      rm -f  bin/cache/*.stamp
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };

  # Wrap flutter inside an fhs user env to allow execution of binary,
  # like adb from $ANDROID_HOME or java from android-studio.
  fhsEnv = buildFHSUserEnv {
    name = "${drvName}-fhs-env";
    multiPkgs = pkgs: [
      # Flutter only use these certificates
      (runCommand "fedoracert" { } ''
        mkdir -p $out/etc/pki/tls/
        ln -s ${cacert}/etc/ssl/certs $out/etc/pki/tls/certs
      '')
      pkgs.zlib
    ];
    targetPkgs = pkgs:
      with pkgs; [
        bash
        curl
        git
        unzip
        which
        xz

        # flutter test requires this lib
        libGLU

        # for android emulator
        alsaLib
        dbus
        expat
        libpulseaudio
        libuuid
        libX11
        libxcb
        libXcomposite
        libXcursor
        libXdamage
        libXfixes
        libGL
        nspr
        nss
        systemd
      ];
  };

in runCommand drvName {
  startScript = ''
    #!${bash}/bin/bash
    export PUB_CACHE=''${PUB_CACHE:-"$HOME/.pub-cache"}
    export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
    ${fhsEnv}/bin/${drvName}-fhs-env ${flutter}/bin/flutter --no-version-check "$@"
  '';
  preferLocalBuild = true;
  allowSubstitutes = false;
  passthru = { unwrapped = flutter; };
  meta = with stdenv.lib; {
    description =
      "Flutter is Google's SDK for building mobile, web and desktop with Dart.";
    longDescription = ''
      Flutter is Google’s UI toolkit for building beautiful,
      natively compiled applications for mobile, web, and desktop from a single codebase.
    '';
    homepage = "https://flutter.dev";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ babariviere ];
  };
} ''
  mkdir -p $out/bin

  echo -n "$startScript" > $out/bin/${pname}
  chmod +x $out/bin/${pname}
''
