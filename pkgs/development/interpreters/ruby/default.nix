{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ruby-1.8.4";
  src = fetchurl {
    url = ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.4.tar.gz;
    md5 = "bd8c2e593e1fa4b01fd98eaf016329bb";
  };
}
