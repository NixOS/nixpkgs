{ stdenv, fetchurl, libdbi, mysql ? null, sqlite ? null }:

stdenv.mkDerivation rec {
  name = "libdbi-drivers-0.8.3-1";

  src = fetchurl {
    url = "mirror://sourceforge/libdbi-drivers/${name}.tar.gz";
    sha256 = "0wng59xnq8jjyp6f3bfjrhjvqrswamrjykdnxq6rqxnfk11r9faa";
  };

  buildInputs = [ libdbi mysql sqlite ];

  configureFlags =
    [ "--disable-docs"
      "--enable-libdbi"
      "--with-dbi-incdir=${libdbi}/include"
      "--with-dbi-libdir=${libdbi}/lib"
    ] ++ stdenv.lib.optionals (mysql != null)
    [ "--with-mysql"
      "--with-mysql-incdir=${mysql}/include/mysql"
      "--with-mysql-libdir=${mysql}/lib/mysql"
    ] ++ stdenv.lib.optionals (sqlite != null)
    [ "--with-sqlite3"
      "--with-sqlite3-incdir=${sqlite}/include/sqlite"
      "--with-sqlite3-libdir=${sqlite}/lib/sqlite"
    ];
    
  meta = {
    description = "Database drivers for libdbi";
  };
}
