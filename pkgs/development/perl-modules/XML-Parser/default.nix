{stdenv, fetchurl, perl, expat}:

assert perl != null && expat != null;

derivation {
  name = "perl-XML-Parser-2.34";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://search.cpan.org/CPAN/authors/id/M/MS/MSERGEANT/XML-Parser-2.34.tar.gz;
    md5 = "84d9e0001fe01c14867256c3fe115899";
  };
  stdenv = stdenv;
  perl = perl;
  expat = expat;
}
