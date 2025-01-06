{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage rec {
  pname = "ocaml-version";
  version = "3.7.2";

  src = fetchurl {
    url = "https://github.com/ocurrent/ocaml-version/releases/download/v${version}/ocaml-version-${version}.tbz";
    hash = "sha256-fTbh4fAJkkQr8Az6Limt5i8/zQnxTZSrhbfK8i08da0=";
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
