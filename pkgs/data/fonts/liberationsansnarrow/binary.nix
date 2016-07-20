{ stdenv, fetchurl, liberationsansnarrow }:

stdenv.mkDerivation rec {
  version = "1.07.3";
  name = "liberationsansnarrow-${version}";
  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/liberation-fonts/liberation-fonts-ttf-${version}.tar.gz";
    sha256 = "0qkr7n97jmj4q85jr20nsf6n5b48j118l9hr88vijn22ikad4wsp";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v $(find . -name '*Narrow*.ttf') $out/share/fonts/truetype

    mkdir -p "$out/doc/${name}"
    cp -v AUTHORS ChangeLog COPYING License.txt README "$out/doc/${name}" || true
  '';

  inherit (liberationsansnarrow) meta;
}
