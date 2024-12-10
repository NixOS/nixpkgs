{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "generate_html";
  version = "0.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-CHJ0+90+SNXmslLrQc+8aetSnHK0m9PqEBipFuFjwHw=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/generate_html/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Provides functions for generating HTML pages that contain the help texts for a set of functions";
    longDescription = ''
      This package provides functions for generating HTML pages that contain
      the help texts for a set of functions. The package is designed to be as
      general as possible, but also contains convenience functions for generating
      a set of pages for entire packages.
    '';
  };
}
