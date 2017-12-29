{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "latinmodern-math-${version}";
  version = "1.959";

  src = fetchzip {
    url = "www.gust.org.pl/projects/e-foundry/lm-math/download/latinmodern-math-1959.zip";
    sha256 = "15l3lxjciyjmbh0q6jjvzz16ibk4ij79in9fs47qhrfr2wrddpvs";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/
    mkdir -p $out/share/doc/${name}/
    cp otf/*.otf $out/share/fonts/opentype/
    cp doc/*.txt $out/share/doc/${name}/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "05k145bxgxjh7i9gx1ahigxfpc2v2vwzsy2mc41jvvg51kjr8fnn";

  meta = with stdenv.lib; {
    description = "The Latin Modern Math (LM Math) font completes the modernization of the Computer Modern family of typefaces designed and programmed by Donald E. Knuth.";
    homepage = http://www.gust.org.pl/projects/e-foundry/lm-math;
    # "The Latin Modern Math font is licensed under the GUST Font License (GFL),
    # which is a free license, legally equivalent to the LaTeX Project Public
    # License (LPPL), version 1.3c or later." - GUST website
    license = licenses.lppl13c;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
