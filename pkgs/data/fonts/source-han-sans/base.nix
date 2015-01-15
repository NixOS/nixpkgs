{version ? "1.001R", sha256 ? "0cwz3d8jancl0a7vbjxhnh1vgwsjba62lahfjya9yrjkp1ndxlap", region, prefix, description}:

{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  inherit version;
  name = "${prefix}-${version}";

  src = fetchurl {
    url = "https://github.com/adobe-fonts/source-han-sans/archive/${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $( find SubsetOTF/${region} -name '*.otf' ) $out/share/fonts/truetype
  '';

  meta = {
    inherit description;

    homepage = https://github.com/adobe-fonts/source-han-sans;
    license = stdenv.lib.licenses.asl20;
  };
}
