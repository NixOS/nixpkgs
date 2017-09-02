{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "libvisual-0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/libvisual/${name}.tar.gz";
    sha256 = "1my1ipd5k1ixag96kwgf07bgxkjlicy9w22jfxb2kq95f6wgsk8b";
  };

  buildInputs = [ pkgconfig glib ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "An abstraction library for audio visualisations";
    homepage = http://sourceforge.net/projects/libvisual/;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
