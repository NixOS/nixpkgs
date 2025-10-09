{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage rec {
  pname = "ocaml-version";
  version = "4.0.1";

  src = fetchurl {
    url = "https://github.com/ocurrent/ocaml-version/releases/download/v${version}/ocaml-version-${version}.tbz";
    hash = "sha256-uZ7c47uaHpTt1XyCcsxo/E7P2grk09UzRTEnUBKYKNA=";
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
