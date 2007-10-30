{stdenv, fetchurl, flex, bison, libxml2, apacheHttpd, unixODBC ? null, postgresql ? null, mysql ? null}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "php-5.2.4";
  src = fetchurl {
    url = http://nl3.php.net/distributions/php-5.2.4.tar.bz2;
    sha256 = "1h513j7crz08n7rlh8v7cvxfzisj87mvvyfrkiaa76v1wicm4bsh";
  };
  
  inherit flex bison libxml2 apacheHttpd;

  builder = ./builder.sh;

  buildInputs = [flex bison libxml2 apacheHttpd];

  inherit unixODBC postgresql mysql;
  
  odbcSupport = unixODBC != null;

  patches = [./fix.patch];
}
