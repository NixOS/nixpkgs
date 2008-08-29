{fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "libcddb-1.3.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/libcddb/${name}.tar.bz2";
    sha256 = "1y8bfy12dwm41m1jahayn3v47dm34fmz7m9cjxyh7xcw6fp3lzaf";
  };

  meta = {
    description = "Libcddb is a C library to access data on a CDDB server (freedb.org)";
    license = "LGPLv2+";
    homepage = http://libcddb.sourceforge.net/;
  };
}
