{ lib, buildDunePackage, fetchurl, pcre, dune-configurator }:

buildDunePackage rec {
  pname = "pcre";
  version = "8.0.2";

  useDune2 = true;

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/pcre-ocaml/releases/download/${version}/pcre-${version}.tbz";
    sha256 = "sha256-LBnTZbmNmcZrbcUK1+oD/Hz+YqCmDCt/X2z45bJov/4=";
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ pcre ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/pcre-ocaml";
    description = "Efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ maggesi vbmithr ];
  };
}
