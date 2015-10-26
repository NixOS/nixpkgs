{ stdenv, fetchurl, file, openssl, mlton
, mysql, postgresql, sqlite
}:

stdenv.mkDerivation rec {
  name = "urweb-${version}";
  version = "20151018";

  src = fetchurl {
    url = "http://www.impredicative.com/ur/${name}.tgz";
    sha256 = "08p52p5m1xl2gzdchnayky44mm2b0x8hv0f00iviyyv1gnx3lpy0";
  };

  buildInputs = [ openssl mlton mysql postgresql sqlite ];

  prePatch = ''
    sed -e 's@/usr/bin/file@${file}/bin/file@g' -i configure
  '';

  configureFlags = "--with-openssl=${openssl}";

  preConfigure = ''
    export PGHEADER="${postgresql}/include/libpq-fe.h";
    export MSHEADER="${mysql.lib}/include/mysql/mysql.h";
    export SQHEADER="${sqlite}/include/sqlite3.h";

    export CCARGS="-I$out/include \
                   -L${mysql.lib}/lib/mysql \
                   -L${postgresql}/lib \
                   -L${sqlite}/lib";
  '';

  # Be sure to keep the statically linked libraries
  dontDisableStatic = true;

  meta = {
    description = "Advanced purely-functional web programming language";
    homepage    = "http://www.impredicative.com/ur/";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
