{ pname
, version
, patches
, dart
, src
}:

{ bash
, buildFHSUserEnv
, cacert
, git
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
}:
let
  drvName = "flutter-${version}";
  flutter = stdenv.mkDerivation {
    name = "${drvName}-unwrapped";

    buildInputs = [ git ];

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

      HOME=../.. # required for pub upgrade --offline, ~/.pub-cache
                 # path is relative otherwise it's replaced by /build/flutter

      pushd "$FLUTTER_TOOLS_DIR"
      ${dart}/bin/dart pub get --offline
      popd

      local revision="$(cd "$FLUTTER_ROOT"; git rev-parse HEAD)"
      ${dart}/bin/dart --snapshot="$SNAPSHOT_PATH" --packages="$FLUTTER_TOOLS_DIR/.packages" "$SCRIPT_PATH"
      echo "$revision" > "$STAMP_PATH"
      echo -n "${version}" > version

      rm -r bin/cache/{artifacts,dart-sdk,downloads}
      rm bin/cache/*.stamp
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out
      mkdir -p $out/bin/cache/
      ln -sf ${dart} $out/bin/cache/dart-sdk

      runHook postInstall
    '';

    doInstallCheck = true;
    installCheckInputs = [ which ];
    installCheckPhase = ''
      runHook preInstallCheck

      export HOME="$(mktemp -d)"
      $out/bin/flutter config --android-studio-dir $HOME
      $out/bin/flutter config --android-sdk $HOME
      $out/bin/flutter --version | fgrep -q '${version}'

      runHook postInstallCheck
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
        dart
        git
        unzip
        which
        xz

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
        nspr
        nss
        systemd
      ];
  };

in
let
self = (self:
runCommand drvName
{
  startScript = ''
    #!${bash}/bin/bash
    export PUB_CACHE=''${PUB_CACHE:-"$HOME/.pub-cache"}
    export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
    ${fhsEnv}/bin/${drvName}-fhs-env ${flutter}/bin/flutter --no-version-check "$@"
  '';
  preferLocalBuild = true;
  allowSubstitutes = false;
  passthru = {
    unwrapped = flutter;
    inherit dart;
    mkFlutterApp = callPackage ../../../build-support/flutter {
      flutter = self;
    };
  };
  meta = with lib; {
    description = "Flutter is Google's SDK for building mobile, web and desktop with Dart";
    longDescription = ''
      Flutter is Google’s UI toolkit for building beautiful,
      natively compiled applications for mobile, web, and desktop from a single codebase.
    '';
    homepage = "https://flutter.dev";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ babariviere ericdallo ];
  };
} ''
  mkdir -p $out/bin

  mkdir -p $out/bin/cache/
  ln -sf ${dart} $out/bin/cache/dart-sdk

  echo -n "$startScript" > $out/bin/${pname}
  chmod +x $out/bin/${pname}
'') self;
in
self
