{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "overpass-${version}";
  version = "2.1";

  src = fetchurl {
    url = "https://github.com/RedHatBrand/overpass/releases/download/2.1/overpass-fonts-ttf-2.1.zip";
    sha256 = "1kd7vbqffp5988j3p4zxkxajdmfviyv4y6rzk7jazg81xcsxicwf";
  };

  nativeBuildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/doc/${name}
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype
    cp -v LICENSE.md README.md $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://overpassfont.org/;
    description = "Font heavily inspired by Highway Gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
