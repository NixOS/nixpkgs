{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coredumper-0.2";
  src = fetchurl {
    url = mirror://sourceforge/goog-coredumper/coredumper-0.2.tar.gz;
    md5 = "024f8e4afe73c4cc4f4a0b0ef585e9b7";
  };
}
