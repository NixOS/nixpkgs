{ stdenv, fetchurl, liberation_ttf_from_source }:

stdenv.mkDerivation rec {
  version = "2.00.1";
  name = "liberation-fonts-${version}";
  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/liberation-fonts/liberation-fonts-ttf-${version}.tar.gz";
    sha256 = "010m4zfqan4w04b6bs9pm3gapn9hsb18bmwwgp2p6y6idj52g43q";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v $( find . -name '*.ttf') $out/share/fonts/truetype

    mkdir -p "$out/doc/${name}"
    cp -v AUTHORS ChangeLog COPYING License.txt README "$out/doc/${name}" || true
  '';

  inherit (liberation_ttf_from_source) meta;
}
