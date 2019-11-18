{ stdenv, fetchurl, file, openssl, mlton
, mysql, postgresql, sqlite, gcc, icu
}:

stdenv.mkDerivation rec {
  pname = "urweb";
  version = "20190217";

  src = fetchurl {
    url = "https://github.com/urweb/urweb/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1cl0x0sy7w1lazszc8q06q3wx0x0rczxh27vimrsw54s6s9y096s";
  };

  buildInputs = [ openssl mlton mysql.connector-c postgresql sqlite icu ];

  prePatch = ''
    sed -e 's@/usr/bin/file@${file}/bin/file@g' -i configure
  '';

  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  preConfigure = ''
    export PGHEADER="${postgresql}/include/libpq-fe.h";
    export MSHEADER="${stdenv.lib.getDev mysql.connector-c}/include/mysql/mysql.h";
    export SQHEADER="${sqlite.dev}/include/sqlite3.h";

    export CC="${gcc}/bin/gcc";
    export CCARGS="-I$out/include \
                   -L${openssl.out}/lib \
                   -L${mysql.connector-c}/lib \
                   -L${postgresql.lib}/lib \
                   -L${sqlite.out}/lib";
  '';

  # Be sure to keep the statically linked libraries
  dontDisableStatic = true;

  meta = {
    description = "Advanced purely-functional web programming language";
    homepage    = "http://www.impredicative.com/ur/";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice stdenv.lib.maintainers.sheganinans ];
  };
}
