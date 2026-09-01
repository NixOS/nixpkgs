{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "dscheck";
  version = "0.6.0";

  minimalOCamlVersion = "5.2";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/dscheck/releases/download/${finalAttrs.version}/dscheck-${finalAttrs.version}.tbz";
    hash = "sha256-//li4+7Y1kWjU5V3uTUF1kLZr+M7KeJPkOZx03UOe6w=";
  };

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Traced atomics";
    homepage = "https://github.com/ocaml-multicore/dscheck";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
