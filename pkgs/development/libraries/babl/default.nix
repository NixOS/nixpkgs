{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "babl";
  version = "0.1.66";

  src = fetchurl {
    url = "https://ftp.gtk.org/pub/babl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0qx1dwbinxihwl2lmxi60qiqi402jlrdcnixx14kk6j88n9xi79n";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
