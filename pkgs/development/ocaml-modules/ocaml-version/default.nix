{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "ocaml-version";
  version = "4.1.4";

  src = fetchurl {
    url = "https://github.com/ocurrent/ocaml-version/releases/download/v${finalAttrs.version}/ocaml-version-${finalAttrs.version}.tbz";
    hash = "sha256-Iiik1STIuLd1639h99JE64H/2sowC3jCnY/drKWkPbI=";
  };

  checkInputs = [ alcotest ];

  doCheck = true;

  minimalOCamlVersion = "4.07";
  duneVersion = "3";

  meta = {
    description = "Manipulate, parse and generate OCaml compiler version strings";
    homepage = "https://github.com/ocurrent/ocaml-version";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
