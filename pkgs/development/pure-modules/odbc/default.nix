{ lib, stdenv, fetchurl, pkg-config, pure, libiodbc }:

stdenv.mkDerivation rec {
  pname = "pure-odbc";
  version = "0.10";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-odbc-${version}.tar.gz";
    sha256 = "1907e9ebca11cc68762cf7046084b31e9e2bf056df85c40ccbcbe9f02221ff8d";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure libiodbc ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A simple ODBC interface for the Pure programming language";
    homepage = "http://puredocs.bitbucket.org/pure-odbc.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
