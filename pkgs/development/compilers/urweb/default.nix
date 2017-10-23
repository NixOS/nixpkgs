{ stdenv, lib, fetchurl, file, openssl, mlton
, mysql, postgresql, sqlite, gcc
}:

stdenv.mkDerivation rec {
  name = "urweb-${version}";
  version = "20170720";

  src = fetchurl {
    url = "http://www.impredicative.com/ur/${name}.tgz";
    sha256 = "17qh9mcmlhbv6r52yij8l9ik7j7x6x7c09lf6pznnbdh4sf8p5wb";
  };

  buildInputs = [ openssl mlton mysql.client postgresql sqlite ];

  prePatch = ''
    sed -e 's@/usr/bin/file@${file}/bin/file@g' -i configure
  '';

  configureFlags = "--with-openssl=${openssl.dev}";

  preConfigure = ''
    export PGHEADER="${postgresql}/include/libpq-fe.h";
    export MSHEADER="${lib.getDev mysql.client}/include/mysql/mysql.h";
    export SQHEADER="${sqlite.dev}/include/sqlite3.h";

    export CC="${gcc}/bin/gcc";
    export CCARGS="-I$out/include \
                   -L${openssl.out}/lib \
                   -L${lib.getLib mysql.client}/lib \
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
