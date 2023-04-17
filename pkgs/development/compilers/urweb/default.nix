{ lib, stdenv, fetchurl, file, openssl, mlton
, libmysqlclient, postgresql, sqlite, gcc, icu
}:

stdenv.mkDerivation rec {
  pname = "urweb";
  version = "20200209";

  src = fetchurl {
    url = "https://github.com/urweb/urweb/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0qh6wcxfk5kf735i5gqwnkdirnnmqhnnpkfz96gz144dgz2i0c5c";
  };

  buildInputs = [ openssl mlton libmysqlclient postgresql sqlite icu ];

  prePatch = ''
    sed -e 's@/usr/bin/file@${file}/bin/file@g' -i configure
  '';

  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  preConfigure = ''
    export PGHEADER="${lib.getDev postgresql}/include/libpq-fe.h";
    export MSHEADER="${lib.getDev libmysqlclient}/include/mysql/mysql.h";
    export SQHEADER="${lib.getDev sqlite}/include/sqlite3.h";
    export ICU_INCLUDES="-I${lib.getDev icu}/include";

    export CC="${gcc}/bin/gcc";
    export CCARGS="-I$out/include \
                   -L${lib.getLib openssl}/lib \
                   -L${libmysqlclient}/lib \
                   -L${postgresql.lib}/lib \
                   -L${sqlite.out}/lib";
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=use-after-free"
  ];

  # Be sure to keep the statically linked libraries
  dontDisableStatic = true;

  meta = {
    description = "Advanced purely-functional web programming language";
    homepage    = "http://www.impredicative.com/ur/";
    license     = lib.licenses.bsd3;
    platforms   = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.thoughtpolice lib.maintainers.sheganinans ];
  };
}
