{ stdenv, fetchurl, pkgconfig, gtk3, mate, pythonPackages }:

stdenv.mkDerivation rec {
  name = "caja-dropbox-${version}";
  version = "1.18.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "18wd8abjaxa68n1yjmvh9az1m8lqa2wing73xdymz0d5gmxmk25g";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    gtk3
    mate.caja
    pythonPackages.python
    pythonPackages.pygtk
    pythonPackages.docutils
  ];

  configureFlags = [ "--with-caja-extension-dir=$$out/lib/caja/extensions-2.0" ];

  meta = with stdenv.lib; {
    description = "Dropbox extension for Caja file manager";
    homepage = https://github.com/mate-desktop/caja-dropbox;
    license = with licenses; [ gpl3 cc-by-nd-30 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
