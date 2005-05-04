{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ruby-1.8.2";
  src = fetchurl {
    url = ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.2.tar.gz;
    md5 = "8ffc79d96f336b80f2690a17601dea9b";
  };
}
