{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "kawkab-mono-20151015";

  src = fetchurl {
    url = "http://makkuk.com/kawkab-mono/downloads/kawkab-mono-0.1.zip";
    sha256 = "16pv9s4q7199aacbzfi2d10rcrq77vyfvzcy42g80nhfrkz1cb0m";
  };

  buildInputs = [ unzip ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "An arab fixed-width font";
    homepage = https://makkuk.com/kawkab-mono/;
    license = stdenv.lib.licenses.ofl;
    platforms = stdenv.lib.platforms.unix;
  };
}


