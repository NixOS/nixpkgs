{stdenv, fetchurl, perl, db4}:

assert !isNull perl && !isNull db4;

derivation {
  name = "perl-BerkeleyDB-0.23";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://archive.cs.uu.nl/mirror/CPAN/authors/id/P/PM/PMQS/BerkeleyDB-0.23.tar.gz;
    md5 = "d97b85ea5b61bde7de4a998c91ef29c7";
  };
  stdenv = stdenv;
  perl = perl;
  db4 = db4;
}
