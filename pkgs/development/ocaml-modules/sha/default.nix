{ lib, fetchurl, buildDunePackage, stdlib-shims, ounit2 }:

buildDunePackage rec {
  pname = "sha";
  version = "1.15.2";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/djs55/ocaml-${pname}/releases/download/${version}/${pname}-${version}.tbz";
    hash = "sha256-P71Xs5p8QAaOtBrh7MuhQJOL6144BqTLvXlZOyGD/7c=";
  };

  propagatedBuildInputs = [
    stdlib-shims
  ];

  doCheck = true;
  nativeCheckInputs = [
    ounit2
  ];

  meta = with lib; {
    description = "Binding for SHA interface code in OCaml";
    homepage = "https://github.com/djs55/ocaml-sha/";
    license = licenses.isc;
    maintainers = with maintainers; [ arthurteisseire ];
  };
}
