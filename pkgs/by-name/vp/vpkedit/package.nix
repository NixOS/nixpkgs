{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  xcb-util-cursor,
  xcbutilkeysyms,
  xcbutilwm,
  gtkd,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "vpkedit";
  version = "4.4.2";

  src = fetchurl {
    url = "https://github.com/craftablescience/ppa/raw/refs/heads/main/debian/package-VPKEdit_${version}_amd64.deb";
    hash = "sha256-Fs8h/teSdI2kQzA8xcLDGIFhbq8RC7Z5KOKaA+78Plc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    xcb-util-cursor
    xcbutilkeysyms
    xcbutilwm
    gtkd
    openssl
  ];

  buildInputs = [ dpkg ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/opt/vpkedit/* $out
    rm -rf $out/opt
    mv $out/usr/share $out/share
    rm -rf $out/usr
    substituteInPlace $out/share/applications/vpkedit.desktop \
      --replace-fail "/opt/vpkedit/vpkedit" "vpkedit"
    mkdir -p $out/share/licenses/vpkedit
    mv $out/LICENSE $out/share/licenses/vpkedit/LICENSE

    # Create symlink libxcb-cursor library
    ln -s ${openssl.out}/lib/libcrypto.so.3 $out/libcrypto.so.3
    ln -s ${openssl.out}/lib/libssl.so.3 $out/libssl.so.3
    ln -s ${xcb-util-cursor.out}/lib/libxcb-cursor.so.0 $out/libxcb-cursor.so.0
  '';

  meta = with lib; {
    description = "A CLI/GUI tool to create, read, and write several pack file formats.";
    homepage = "https://github.com/craftablescience/VPKEdit";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ srp ];
  };
}
