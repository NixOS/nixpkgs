{stdenv, fetchurl}: derivation {
  name = "python-2.3.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
      url = http://www.python.org/ftp/python/2.3.3/Python-2.3.3.tar.bz2;
      md5 = "70ada9f65742ab2c77a96bcd6dffd9b1";
    };
  stdenv = stdenv;
}
