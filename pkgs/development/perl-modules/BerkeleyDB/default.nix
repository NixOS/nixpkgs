{stdenv, fetchurl, perl, db4}:

assert perl != null && db4 != null;

stdenv.mkDerivation {
  name = "perl-BerkeleyDB-0.25";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/CPAN/authors/id/P/PM/PMQS/BerkeleyDB-0.25.tar.gz;
    md5 = "fcef06232d1ccd6c2a9cd114e388ea3d";
  };
  perl = perl;
  db4 = db4;
}
