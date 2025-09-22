{
  lib,
  fetchurl,
  buildDunePackage,
  liquidsoap,
}:

buildDunePackage rec {
  pname = "csexp";
  version = "1.5.2";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    hash = "sha256-GhTdBLtDeaQZkCSFUGKMd5E6nAfzw1wTcLaWDml3h/8=";
  };

  minimalOCamlVersion = "4.03";

  passthru.tests = {
    inherit liquidsoap;
  };

  meta = with lib; {
    description = "Minimal support for Canonical S-expressions";
    homepage = "https://github.com/ocaml-dune/csexp";
    changelog = "https://github.com/ocaml-dune/csexp/raw/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
