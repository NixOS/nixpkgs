{ lib, stdenv, fetchurl,
  pkg-config, pure, glpk, gmp, libtool, libmysqlclient, libiodbc }:

stdenv.mkDerivation rec {
  pname = "pure-glpk";
  version = "0.5";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-glpk-${version}.tar.gz";
    sha256 = "5d6dc11706985dda02d96d481ea5f164c9e95ee446432fc4fc3d0db61a076346";
  };

  glpkWithExtras = lib.overrideDerivation glpk (attrs: {
    propagatedBuildInputs = [ gmp libtool libmysqlclient libiodbc ];

    CPPFLAGS = "-I${gmp.dev}/include";

    preConfigure = ''
      substituteInPlace configure \
        --replace /usr/include/mysql ${libmysqlclient}/include/mysql
    '';
    configureFlags = [ "--enable-dl"
                       "--enable-odbc"
                       "--enable-mysql"
                       "--with-gmp=yes" ];
  });

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure glpkWithExtras ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "GLPK interface for the Pure Programming Language";
    homepage = "http://puredocs.bitbucket.org/pure-glpk.html";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
