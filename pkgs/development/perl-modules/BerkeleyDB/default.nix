{stdenv, fetchurl, perl, db4}:

assert !isNull perl && !isNull db4;

derivation {
  name = "perl-BerkeleyDB-0.25";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/CPAN/authors/id/P/PM/PMQS/BerkeleyDB-0.25.tar.gz;
    md5 = "fcef06232d1ccd6c2a9cd114e388ea3d";
  };
  stdenv = stdenv;
  perl = perl;
  db4 = db4;
}
