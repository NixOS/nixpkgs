{ buildDunePackage, bisect_ppx, ocamlbuild }:

buildDunePackage rec {
  inherit (bisect_ppx) version src meta;
  pname = "bisect_ppx-ocamlbuild";
  propagatedBuildInputs = [ ocamlbuild ];
}
