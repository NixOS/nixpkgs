{ buildDunePackage, bisect_ppx, ocamlbuild }:

buildDunePackage {
  minimumOCamlVersion = "4.02";
  inherit (bisect_ppx) version src meta;
  pname = "bisect_ppx-ocamlbuild";
  propagatedBuildInputs = [ ocamlbuild ];
}
