{ fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "talloc-2.0.1";

  src = fetchurl {
    url = "http://samba.org/ftp/talloc/${name}.tar.gz";
    md5 = "c6e736540145ca58cb3dcb42f91cf57b";
  };

  configureFlags = "--enable-talloc-compat1 --enable-largefile";
  meta = {
    description = "talloc is a hierarchical pool based memory allocator with destructors";

    homepage = http://tdb.samba.org/;
    license = "GPLv3";

    platforms = stdenv.lib.platforms.all;
  };
}
