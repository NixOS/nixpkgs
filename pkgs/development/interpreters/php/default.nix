{stdenv, fetchurl, flex, bison, libxml2, apacheHttpd, unixODBC ? null, postgresql ? null}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "php-5.2.0";
  src = fetchurl {
    url = http://nl2.php.net/distributions/php-5.2.0.tar.bz2;
    md5 = "e6029fafcee029edcfa2ceed7a005333";
  };
  
  inherit flex bison libxml2 apacheHttpd;

  builder = ./builder.sh;

  buildInputs = [flex bison libxml2 apacheHttpd];

  inherit unixODBC postgresql;
  
  odbcSupport = unixODBC != null;

  patches = [./fix.patch];
}
