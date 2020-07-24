{ stdenv, fetchurl, pkgconfig, gettext, gtk3, mate, python3Packages }:

stdenv.mkDerivation rec {
  pname = "python-caja";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1wp61q64cgzr3syd3niclj6rjk87wlib5m86i0myf5ph704r3qgg";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    python3Packages.wrapPython
  ];

  buildInputs = [
    gtk3
    mate.caja
    python3Packages.python
    python3Packages.pygobject3
  ];

  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Python binding for Caja components";
    homepage = "https://github.com/mate-desktop/python-caja";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
