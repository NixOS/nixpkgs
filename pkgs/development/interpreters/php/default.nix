{stdenv, fetchurl, flex, bison, libxml2, apacheHttpd, unixODBC ? null, postgresql ? null}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "php-5.0.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/php-5.0.4.tar.bz2;
    md5 = "fb1aac107870f897d26563a9cc5053c0";
  };
  
  inherit flex bison libxml2 apacheHttpd;

  builder = ./builder.sh;

  buildInputs = [flex bison libxml2 apacheHttpd];

  inherit unixODBC postgresql;
  
  odbcSupport = unixODBC != null;

  patches = [./fix.patch];
}
