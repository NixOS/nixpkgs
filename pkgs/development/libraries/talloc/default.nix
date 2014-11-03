{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "talloc-2.0.1";

  src = fetchurl {
    url = "http://samba.org/ftp/talloc/${name}.tar.gz";
    sha256 = "1d694zyi451a5zr03l5yv0n8yccyr3r8pmzga17xaaaz80khb0av";
  };

  configureFlags = "--enable-talloc-compat1 --enable-largefile";
  
  # https://bugzilla.samba.org/show_bug.cgi?id=7000
  postConfigure = if stdenv.isDarwin then ''
    substituteInPlace "Makefile" --replace "SONAMEFLAG = #" "SONAMEFLAG = -Wl,-install_name,"
  '' else "";

  meta = {
    description = "Hierarchical pool based memory allocator with destructors";
    homepage = http://tdb.samba.org/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
