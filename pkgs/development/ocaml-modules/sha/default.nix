{ lib, fetchurl, buildDunePackage, stdlib-shims, ounit2 }:

buildDunePackage rec {
  pname = "sha";
  version = "1.15.4";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/djs55/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-beWxITmxmZzp30zHiloxiGwqVHydRIvyhT+LU7zx8bE=";
  };

  propagatedBuildInputs = [
    stdlib-shims
  ];

  doCheck = true;
  checkInputs = [
    ounit2
  ];

  meta = with lib; {
    description = "Binding for SHA interface code in OCaml";
    homepage = "https://github.com/djs55/ocaml-sha/";
    license = licenses.isc;
    maintainers = with maintainers; [ arthurteisseire ];
  };
}
