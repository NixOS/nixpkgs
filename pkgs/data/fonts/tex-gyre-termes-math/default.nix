{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "tex-gyre-termes-math-${version}";
  version = "1.543";

  src = fetchzip {
    url = "www.gust.org.pl/projects/e-foundry/tg-math/download/texgyretermes-math-1543.zip";
    sha256 = "10ayqfpryfn1l35hy0vwyjzw3a6mfsnzgf78vsnccgk2gz1g9vhz";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/
    mkdir -p $out/share/doc/${name}/
    cp -v opentype/*.otf $out/share/fonts/opentype/
    cp -v doc/*.txt $out/share/doc/${name}/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0pa433cgshlypbyrrlp3qq0wg972rngcp37pr8pxdfshgz13q1mm";

  meta = with stdenv.lib; {
    longDescription = ''
      TeX Gyre Termes Math is a math companion for the TeX Gyre Termes family
      of fonts (see http://www.gust.org.pl/projects/e-foundry/tex-gyre/) in
      the OpenType format.
    '';
    homepage = http://www.gust.org.pl/projects/e-foundry/tg-math;
    # "The TeX Gyre Math fonts are licensed under the GUST Font License (GFL),
    # which is a free license, legally equivalent to the LaTeX Project Public
    # License (LPPL), version 1.3c or later." - GUST website
    license = licenses.lppl13c;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
