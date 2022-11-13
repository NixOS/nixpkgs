{ pname
, version
, patches
, dart
, src
, supportsLinuxDesktop ? true
}:

{ bash
, buildFHSUserEnv
, cacert
, git
, runCommandLocal
, writeShellScript
, makeWrapper
, stdenv
, lib
, alsa-lib
, atk
, cairo
, clang
, cmake
, dbus
, expat
, gdk-pixbuf
, glib
, gtk3
, harfbuzz
, libepoxy
, libGL
, libpulseaudio
, libuuid
, libX11
, libxcb
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrender
, libXtst
, ninja
, nspr
, nss
, pango
, pkg-config
, systemd
, which
, xorgproto
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
      ${dart}/bin/dart --snapshot="$SNAPSHOT_PATH" --packages="$FLUTTER_TOOLS_DIR/.dart_tool/package_config.json" "$SCRIPT_PATH"
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
  #
  # Also provide libraries at hardcoded locations for Linux desktop target
  # compilation and execution.
  fhsEnv = buildFHSUserEnv {
    name = "${drvName}-fhs-env";
    multiPkgs = pkgs:
      with pkgs; ([
        # Flutter only use these certificates
        (runCommandLocal "fedoracert" { } ''
          mkdir -p $out/etc/pki/tls/
          ln -s ${cacert}/etc/ssl/certs $out/etc/pki/tls/certs
        '')
        zlib
      ] ++ pkgs.lib.lists.optionals supportsLinuxDesktop [
        atk
        cairo
        gdk-pixbuf
        glib
        gtk3
        harfbuzz
        libepoxy
        pango
        xorg.libX11
        xorg.libX11.dev
        xorg.xorgproto
      ]);
    targetPkgs = pkgs:
      with pkgs; ([
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
      ]);
    profile = ''
      export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/share/pkgconfig"
    '';
  };

in
let
self = (self:
runCommandLocal drvName
{
  flutterWithCorrectedCache = writeShellScript "flutter_corrected_cache" ''
    export PUB_CACHE=''${PUB_CACHE:-"$HOME/.pub-cache"}
    ${flutter}/bin/flutter "$@"
  '';
  buildInputs = [
      makeWrapper
      pkg-config
  ] ++ lib.lists.optionals supportsLinuxDesktop (let
    # https://discourse.nixos.org/t/handling-transitive-c-dependencies/5942/3
    deps = pkg: (pkg.buildInputs or []) ++ (pkg.propagatedBuildInputs or []);
    collect = pkg: lib.unique ([ pkg ] ++ deps pkg ++ lib.concatMap collect (deps pkg));
  in
    collect atk.dev ++
    collect cairo.dev ++
    collect gdk-pixbuf.dev ++
    collect glib.dev ++
    collect gtk3.dev ++
    collect harfbuzz.dev ++
    collect libepoxy.dev ++
    collect pango.dev ++
    collect libX11.dev ++
    collect xorgproto);
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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ babariviere ericdallo ];
  };
} ''
    mkdir -p $out/bin

    mkdir -p $out/bin/cache/
    ln -sf ${dart} $out/bin/cache/dart-sdk

    mkdir -p $out/libexec
    makeWrapper "$flutterWithCorrectedCache" $out/libexec/flutter_launcher \
        --set-default ANDROID_EMULATOR_USE_SYSTEM_LIBS 1 \
        --prefix PATH : ${lib.makeBinPath (lib.lists.optionals supportsLinuxDesktop [
            pkg-config
            cmake
            ninja
            clang
          ])} \
        --prefix PKG_CONFIG_PATH : "$PKG_CONFIG_PATH_FOR_TARGET" \
        --add-flags --no-version-check

    makeWrapper ${fhsEnv}/bin/${drvName}-fhs-env $out/bin/${pname} \
        --add-flags $out/libexec/flutter_launcher
'') self;
in
self
