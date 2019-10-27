{ stdenv, fetchurl, pkgconfig, pure, libiodbc }:

stdenv.mkDerivation rec {
  baseName = "odbc";
  version = "0.10";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "1907e9ebca11cc68762cf7046084b31e9e2bf056df85c40ccbcbe9f02221ff8d";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure libiodbc ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A simple ODBC interface for the Pure programming language";
    homepage = http://puredocs.bitbucket.org/pure-odbc.html;
    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
