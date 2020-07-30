{ stdenv, lib, fetchurl
, autoPatchelfHook, makeWrapper
, dtc, expat, freetype, glib, ncurses5, nodejs, pixman, python27
, python27Packages, SDL, xorg, zlib }:

let
  pebbleRpath = lib.makeLibraryPath [ freetype stdenv.cc.cc.lib zlib ];
  pythonLibs = import ./python-libs.nix { inherit fetchurl lib python27; };
  pythonEnv = python27.buildEnv.override {
    ignoreCollisions = true;
    extraLibs = with python27Packages; builtins.attrValues pythonLibs ++ [
      colorama
      enum34
      httplib2
      oauth2client
      packaging
      pyasn1
      pyasn1-modules
      pyqrcode
      pyserial
      requests
      rsa
      virtualenv
      websocket_client
    ];
  };
in stdenv.mkDerivation rec {
  name = "pebble-sdk";
  version = "4.5";

  src = fetchurl {
    url = https://developer.rebble.io/s3.amazonaws.com/assets.getpebble.com/pebble-tool/pebble-sdk-4.5-linux64.tar.bz2;
    sha256 = "15yiypx9rnwyzsn4s4z1wmn1naw6mk7dpsiljmw3078ag66z1ca7";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    dtc
    expat
    glib
    ncurses5
    pixman
    pythonEnv
    SDL
    stdenv.cc.cc.lib
    xorg.libX11
  ];
  propagatedBuildInputs = [ freetype nodejs zlib ];

  # exec-phonesim: Nix wraps python scripts in a shell script. The SDK tool
  # tries to call the phone simulator with python, so patch it to call it
  # directly.
  # fix-virtualenv-commands: The SDK tool was written expecting an older version
  # of virtualenv (13.1.0). It works fine with newer versions, but it uses a
  # flag (--no-site-packages) that was removed and made default behaviour. Patch
  # the tool to not use that flag.
  patches = [
    ./exec-phonesim.patch
    ./fix-virtualenv-commands.patch
  ];

  installPhase = ''
    mkdir -p $out/
    ln -sf $out/pebble-tool/pebble.py bin/pebble
    cp -ax . $out
  '';

  postFixup = ''
    wrapProgram $out/bin/pebble \
      --prefix LD_LIBRARY_PATH : "${pebbleRpath}" \
      --set PEBBLE_PATH $out/ \
      --set PEBBLE_TOOLCHAIN_PATH $out/arm-cs-tools/bin \
      --set PEBBLE_QEMU_PATH $out/bin/qemu-pebble \
      --set PHONESIM_PATH ${pythonLibs.pypkjs}/bin/pypkjs \
      --set PATH $PATH:${nodejs}/bin

    # GDB requires this environment variable to be set, otherwise it just spits
    # out a cryptic "ImportError: No module named site" on startup.
    wrapProgram $out/arm-cs-tools/bin/arm-none-eabi-gdb \
      --set PYTHONPATH ${pythonEnv}/lib/python2.7
  '';

  meta = with lib; {
    homepage = https://developer.rebble.io/developer.pebble.com/index.html;
    description = "The SDK for developing watchfaces and watchapps for Pebble smartwatches";

    # https://developer.rebble.io/developer.pebble.com/legal/sdk-license/index.html
    license = licenses.unfree;

    platforms = platforms.linux;
    maintainers = [ maintainers.sorixelle ];
  };
}
