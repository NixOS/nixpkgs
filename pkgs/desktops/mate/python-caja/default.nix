{ stdenv, fetchurl, pkgconfig, intltool, gtk3, caja, pythonPackages }:

stdenv.mkDerivation rec {
  name = "python-caja-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0n43cvvv29gq31hgrsf9al184cr87c3hzskrh2593rid52kwyz44";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    pythonPackages.wrapPython
  ];

  buildInputs = [
    gtk3
    caja
    pythonPackages.python
    pythonPackages.pygobject3
  ];

  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  meta = with stdenv.lib; {
    description = "Python binding for Caja components";
    homepage = https://github.com/mate-desktop/python-caja;
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
