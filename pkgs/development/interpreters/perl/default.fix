{stdenv, fetchurl}: derivation {
  name = "perl-5.8.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
      url = ftp://ftp.cs.uu.nl/mirror/CPAN/src/5.0/perl-5.8.1.tar.gz;
      md5 = "87cf132f1fbf23e780f0b218046438a6";
    };
  stdenv = stdenv;
}
