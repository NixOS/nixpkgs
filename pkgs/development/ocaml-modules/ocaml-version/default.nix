{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage rec {
  pname = "ocaml-version";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/ocurrent/ocaml-version/releases/download/v${version}/ocaml-version-${version}.tbz";
    hash = "sha256-+xV3bFFWwp2s4OtbBCJCR33l+LctWQVkgwWMrOciPms=";
  };

  checkInputs = [ alcotest ];

  doCheck = true;

  minimalOCamlVersion = "4.07";
  duneVersion = "3";

  meta = with lib; {
    description = "Manipulate, parse and generate OCaml compiler version strings";
    homepage = "https://github.com/ocurrent/ocaml-version";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
