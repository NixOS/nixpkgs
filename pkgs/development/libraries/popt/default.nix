{stdenv, fetchurl, gettext}:

assert !isNull gettext;

derivation {
  name = "popt-1.7";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.rpm.org/pub/rpm/dist/rpm-4.1.x/popt-1.7.tar.gz;
    md5 = "5988e7aeb0ae4dac8d83561265984cc9";
  };
  stdenv = stdenv;
  gettext = gettext;
}
