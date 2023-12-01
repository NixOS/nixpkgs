{ lib
, fetchurl
, buildDunePackage
, alcotest
, mdx
}:

buildDunePackage rec {
  pname = "thread-table";
  version = "1.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "pIzYhGNZfflELEuqaczAYJHKd7px5DjTYJ+64PO4Hd0=";
  };

  doCheck = true;

  checkInputs = [
    alcotest
    mdx
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/ocaml-${pname}";
    changelog = "https://github.com/ocaml-multicore/ocaml-${pname}/raw/${version}/CHANGES.md";
    description = "A lock-free thread-safe integer keyed hash table";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ toastal ];
  };
}
