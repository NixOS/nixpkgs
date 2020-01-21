{ stdenv, fetchurl, cmake, alsaLib, atk, cairo, cups, dbus, expat, fontconfig
, GConf, gdk-pixbuf, glib, gtk2, libX11, libxcb, libXcomposite, libXcursor
, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXScrnSaver
, libXtst, nspr, nss, pango, libpulseaudio, systemd, at-spi2-atk, at-spi2-core
}:

let
  libPath =
    stdenv.lib.makeLibraryPath [
      alsaLib atk cairo cups dbus expat fontconfig GConf gdk-pixbuf glib gtk2
      libX11 libxcb libXcomposite libXcursor libXdamage libXext libXfixes libXi
      libXrandr libXrender libXScrnSaver libXtst nspr nss pango libpulseaudio
      systemd at-spi2-core at-spi2-atk
    ];
in
stdenv.mkDerivation rec {
  pname = "cef-binary";
  version = "74.1.14-g50c3c5c";

  src = fetchurl {
    name = "cef_binary_74.1.14+g50c3c5c+chromium-74.0.3729.131_linux64_minimal.tar.bz2";
    url = "http://opensource.spotify.com/cefbuilds/cef_binary_74.1.19%2Bgb62bacf%2Bchromium-74.0.3729.157_linux64_minimal.tar.bz2";
    sha256 = "0v3540kq4y68gq7mb4d8a9issm363lm5ngrd6d96pcc7vckkw4wn";
  };

  nativeBuildInputs = [ cmake ];
  makeFlags = [ "libcef_dll_wrapper" ];
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
