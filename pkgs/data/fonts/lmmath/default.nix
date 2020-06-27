{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "lmmath";
  version = "1.959";

  src = fetchzip {
    url = "http://www.gust.org.pl/projects/e-foundry/lm-math/download/latinmodern-math-1959.zip";
    sha256 = "15l3lxjciyjmbh0q6jjvzz16ibk4ij79in9fs47qhrfr2wrddpvs";
  };

  meta = with lib; {
    description = "The Latin Modern Math (LM Math) font completes the modernization of the Computer Modern family of typefaces designed and programmed by Donald E. Knuth.";
    homepage = "http://www.gust.org.pl/projects/e-foundry/lm-math";
    # "The Latin Modern Math font is licensed under the GUST Font License (GFL),
    # which is a free license, legally equivalent to the LaTeX Project Public
    # License (LPPL), version 1.3c or later." - GUST website
    license = licenses.lppl13c;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
