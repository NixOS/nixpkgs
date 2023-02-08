{ lib, fetchurl, buildDunePackage
, containers
, oseq
}:

buildDunePackage rec {
  pname = "dscheck";
  version = "0.1.0";

  minimalOCamlVersion = "5.0";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/dscheck/releases/download/${version}/dscheck-${version}.tbz";
    hash = "sha256-zoouFZJcUp71yeluVb1xLUIMcFv99OpkcQQCHkPTKcI=";
  };

  propagatedBuildInputs = [ containers oseq ];

  doCheck = true;

  meta = {
    description = "Traced atomics";
    homepage = "https://github.com/ocaml-multicore/dscheck";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
