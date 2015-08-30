{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "hack-ttf";

  src = fetchurl {
    url = "https://github.com/chrissimpkins/Hack/releases/download/v2.010/Hack-v2_010-ttf.zip";
    sha256 = "14w4bs9sf2fj68yyingj9490yz88ic9zqvzngnlxvz2l67y851yj";
  };

  buildInputs = [ unzip ];

  phases = [ "installPhase" ];

  installPhase = ''
    unzip ${src}
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "TrueType version of the Hack font";
    homepage = http://sourcefoundry.org/hack/;
  };
}
