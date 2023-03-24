{ lib, fetchurl, buildDunePackage, result }:

buildDunePackage rec {
  pname = "csexp";
  version = "1.5.2";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    hash = "sha256-GhTdBLtDeaQZkCSFUGKMd5E6nAfzw1wTcLaWDml3h/8=";
  };

  minimalOCamlVersion = "4.03";

  propagatedBuildInputs = [
    result
  ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-dune/csexp/";
    description = "Minimal support for Canonical S-expressions";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
