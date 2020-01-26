{ stdenv, fetchurl, pkgconfig, intltool, gtk3, mate, python3Packages }:

stdenv.mkDerivation rec {
  pname = "python-caja";
  version = "1.22.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "07hkvs4a6anrvh28zjsrj8anbcz32p19hslhq66yhcvh0hh4kvqk";
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
