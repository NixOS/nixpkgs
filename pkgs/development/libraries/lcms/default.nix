{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lcms-1.17";

  src = fetchurl {
    url = http://www.littlecms.com/lcms-1.17.tar.gz;
    sha256 = "10s5s6b6r5mhf0g6l431l6fwymhjzqrvm7g214h7fmh9ngdb9wsy";
  };

  meta = {
    description = "Color management engine";
    homepage = http://www.littlecms.com/;
    license = "MIT";
  };
}
