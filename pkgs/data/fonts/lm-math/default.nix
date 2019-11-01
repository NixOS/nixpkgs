{ lib, fetchzip }:

let
  version = "1.959";
in fetchzip rec {
  name = "latinmodern-math-${version}";

  url = "http://www.gust.org.pl/projects/e-foundry/lm-math/download/latinmodern-math-1959.zip";
  postFetch = ''
    mkdir -p $out/share/fonts/opentype/
    mkdir -p $out/share/doc/${name}/
    unzip -f $downloadedFile otf/*.otf -d $out/share/fonts/opentype/
    unzip -f $downloadedFile doc/*.txt -d $out/share/doc/${name}/
  '';
  sha256 = "05k145bxgxjh7i9gx1ahigxfpc2v2vwzsy2mc41jvvg51kjr8fnn";

  meta = with lib; {
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
