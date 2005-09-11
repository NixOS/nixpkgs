{stdenv, fetchurl, flex, bison, libxml2, apacheHttpd}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "php-5.0.4";
  src = fetchurl {
    url = http://de.php.net/distributions/php-5.0.4.tar.bz2;
    md5 = "fb1aac107870f897d26563a9cc5053c0";
  };
  
  inherit flex bison libxml2 apacheHttpd;

  buildInputs = [flex bison libxml2 apacheHttpd];
  builder = ./builder.sh ;

  patches = [./fix.patch];
}
