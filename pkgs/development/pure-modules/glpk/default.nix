{ lib, stdenv, fetchurl,
  pkgconfig, pure, glpk, gmp, libtool, libmysql, libiodbc, zlib }:

stdenv.mkDerivation rec {
  baseName = "glpk";
  version = "0.5";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "5d6dc11706985dda02d96d481ea5f164c9e95ee446432fc4fc3d0db61a076346";
  };

  glpkWithExtras = lib.overrideDerivation glpk (attrs: {
    propagatedNativeBuildInputs = [ gmp libtool libmysql libiodbc ];

    CPPFLAGS = "-I${gmp.dev}/include";

    preConfigure = ''
      substituteInPlace configure \
        --replace /usr/include/mysql ${lib.getDev libmysql}/include/mysql
    '';
    configureFlags = [ "--enable-dl"
                       "--enable-odbc"
                       "--enable-mysql"
                       "--with-gmp=yes" ];
  });

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure glpkWithExtras ];
  makeFlags = "libdir=$(out)/lib prefix=$(out)/";
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "GLPK interface for the Pure Programming Language";
    homepage = http://puredocs.bitbucket.org/pure-glpk.html;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
