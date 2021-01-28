{ pname
, version
, patches
, dart
, src
, depsSha256
}:

{ bash
, buildFHSUserEnv
, cacert
, coreutils
, git
, runCommand
, stdenv
, lib
, fetchurl
, alsaLib
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
, libGL
, nspr
, nss
, systemd
, callPackage
}:
let
  repository = callPackage ./repository.nix {
    inherit src pname version dart depsSha256;
  };
  drvName = "flutter-${version}";

  flutter = stdenv.mkDerivation {
    name = "${drvName}-unwrapped";

    buildInputs = [ git repository ];

    inherit src patches;

    postPatch = ''
      patchShebangs --build ./bin/
      find ./bin/ -executable -type f -exec patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) {} \;
    '';

    buildPhase = ''
      export FLUTTER_ROOT="$(pwd)"
      export FLUTTER_TOOLS_DIR="$FLUTTER_ROOT/packages/flutter_tools"
      export SCRIPT_PATH="$FLUTTER_TOOLS_DIR/bin/flutter_tools.dart"

      mkdir -p "$out/bin/cache"
      export SNAPSHOT_PATH="$out/bin/cache/flutter_tools.snapshot"
      export STAMP_PATH="$out/bin/cache/flutter_tools.stamp"

      export DART_SDK_PATH="${dart}"
      export PUB_CACHE="${repository}"

      pushd "$FLUTTER_TOOLS_DIR"
      ${dart}/bin/pub get --offline
      popd

      local revision="$(cd "$FLUTTER_ROOT"; git rev-parse HEAD)"
      ${dart}/bin/dart --snapshot="$SNAPSHOT_PATH" --packages="$FLUTTER_TOOLS_DIR/.packages" "$SCRIPT_PATH"
      echo "$revision" > "$STAMP_PATH"
      echo -n "${version}" > version
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out
      mkdir -p $out/bin/cache/
      ln -sf ${dart} $out/bin/cache/dart-sdk
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

in
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
  passthru = { unwrapped = flutter; };
  meta = with lib; {
    description = "Flutter is Google's SDK for building mobile, web and desktop with Dart";
    longDescription = ''
      Flutter is Google’s UI toolkit for building beautiful,
      natively compiled applications for mobile, web, and desktop from a single codebase.
    '';
    homepage = "https://flutter.dev";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ babariviere ericdallo thiagokokada ];
  };
} ''
  mkdir -p $out/bin

  echo -n "$startScript" > $out/bin/${pname}
  chmod +x $out/bin/${pname}
''
