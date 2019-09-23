{ stdenv, fetchurl, cmake, alsaLib, atk, cairo, cups, dbus, expat, fontconfig
, GConf, gdk-pixbuf, glib, gtk2, libX11, libxcb, libXcomposite, libXcursor
, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXScrnSaver
, libXtst, nspr, nss, pango, libpulseaudio, systemd }:

let
  libPath =
    stdenv.lib.makeLibraryPath [
      alsaLib atk cairo cups dbus expat fontconfig GConf gdk-pixbuf glib gtk2
      libX11 libxcb libXcomposite libXcursor libXdamage libXext libXfixes libXi
      libXrandr libXrender libXScrnSaver libXtst nspr nss pango libpulseaudio
      systemd
    ];
in
stdenv.mkDerivation rec {
  pname = "cef-binary";
  version = "3.3497.1833.g13f506f";
  src = fetchurl {
    url = "http://opensource.spotify.com/cefbuilds/cef_binary_${version}_linux64.tar.bz2";
    sha256 = "02v22yx1ga2yxagjblzkfw0ax7zkrdpc959l1a15m8nah3y7xf9p";
  };
  nativeBuildInputs = [ cmake ];
  makeFlags = "libcef_dll_wrapper";
  dontStrip = true;
  dontPatchELF = true;
  installPhase = ''
    mkdir -p $out/lib/ $out/share/cef/
    cp libcef_dll_wrapper/libcef_dll_wrapper.a $out/lib/
    cp ../Release/libcef.so $out/lib/
    patchelf --set-rpath "${libPath}" $out/lib/libcef.so
    cp ../Release/*.bin $out/share/cef/
    cp -r ../Resources/* $out/share/cef/
    cp -r ../include $out/
  '';

  meta = with stdenv.lib; {
    description = "Simple framework for embedding Chromium-based browsers in other applications";
    homepage = http://opensource.spotify.com/cefbuilds/index.html;
    maintainers = with maintainers; [ puffnfresh ];
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
