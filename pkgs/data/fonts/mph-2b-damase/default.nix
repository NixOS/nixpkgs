{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "MPH-2B-Damase";

  src = fetchurl {
    url = http://www.wazu.jp/downloads/damase_v.2.zip;
    sha256 = "0y7rakbysjjrzcc5y100hkn64j7js434x20pyi6rllnw2w2n1y1h";
  };

  buildInputs = [unzip];

  unpackPhase = ''
    unzip $src;
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
