{version ? "1.000", prefix, url, sha256, description}:

{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  inherit version;
  name = "${prefix}-${version}";

  src = fetchurl {
    inherit url sha256;
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $( find . -name '*.otf' ) $out/share/fonts/truetype
  '';

  meta = {
    inherit description;

    homepage = http://sourceforge.net/adobe/source-han-sans/;
    license = stdenv.lib.licenses.asl20;
  };
}
