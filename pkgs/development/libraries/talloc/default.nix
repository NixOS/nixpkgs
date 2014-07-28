{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "talloc-2.0.1";

  src = fetchurl {
    url = "http://samba.org/ftp/talloc/${name}.tar.gz";
    md5 = "c6e736540145ca58cb3dcb42f91cf57b";
  };

  configureFlags = "--enable-talloc-compat1 --enable-largefile";
  
  # https://bugzilla.samba.org/show_bug.cgi?id=7000
  postConfigure = if stdenv.isDarwin then ''
    substituteInPlace "Makefile" --replace "SONAMEFLAG = #" "SONAMEFLAG = -install_name"
  '' else "";

  meta = {
    description = "talloc is a hierarchical pool based memory allocator with destructors";
    homepage = http://tdb.samba.org/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
