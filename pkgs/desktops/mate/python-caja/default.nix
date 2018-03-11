{ stdenv, fetchurl, pkgconfig, intltool, gtk3, mate, pythonPackages }:

stdenv.mkDerivation rec {
  name = "python-caja-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0bcgg3p01zik53l5ns48575yw0k88fyc044yvp9fvwy5jqqg1ykk";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    pythonPackages.wrapPython
  ];

  buildInputs = [
    gtk3
    mate.caja
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
