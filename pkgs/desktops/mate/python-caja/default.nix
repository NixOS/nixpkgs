{ stdenv, fetchurl, pkgconfig, intltool, gtk3, mate, python3Packages }:

stdenv.mkDerivation rec {
  name = "python-caja-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1zwdjvxci72j0181nlfq6912lw3aq8j3746brlp7wlzn22qp7b0k";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    python3Packages.wrapPython
  ];

  buildInputs = [
    gtk3
    mate.caja
    python3Packages.python
    python3Packages.pygobject3
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
