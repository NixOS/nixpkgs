{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tinycdb";
  version = "0.78";
  outputs = [ "out" "dev" "lib" "man" ];
  separateDebugInfo = true;
  makeFlags = [ "prefix=$(out)" "staticlib" "sharedlib" "cdb-shared" ];
  postInstall = ''
    mkdir -p $lib/lib $dev/lib $out/bin
    cp libcdb.so* $lib/lib
    cp cdb-shared $out/bin/cdb
    mv $out/lib/libcdb.a $dev/lib
    rmdir $out/lib
  '';

  src = fetchurl {
    url = "http://www.corpit.ru/mjt/tinycdb/${pname}-${version}.tar.gz";
    sha256 = "0g6n1rr3lvyqc85g6z44lw9ih58f2k1i3v18yxlqvnla5m1qyrsh";
  };

  meta = with lib; {

    description = "utility to manipulate constant databases (cdb)";

    longDescription = ''
      tinycdb is a small, fast and reliable utility and subroutine
      library for creating and reading constant databases. The database
      structure is tuned for fast reading.
      '';

    homepage = https://www.corpit.ru/mjt/tinycdb.html;
    license = licenses.publicDomain;
    platforms = platforms.linux;
  };
}
