{
  lib,
  ocaml,
  fetchurl,
  buildDunePackage,
  checkseum,
  optint,
  cmdliner,
  alcotest,
  camlzip,
  base64,
  fmt,
  crowbar,
  bstr,
}:

buildDunePackage (finalAttrs: {
  pname = "decompress";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/mirage/decompress/releases/download/v${finalAttrs.version}/decompress-${finalAttrs.version}.tbz";
    hash = "sha256-qi6ELcAJvN3LtcB5H12+7ivaWhBOzHaBqjesQlN+MSE=";
  };

  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [
    optint
    checkseum
  ];
  checkInputs = [
    alcotest
    fmt
    camlzip
    base64
    crowbar
    bstr
  ];
  # bstr is not available for OCaml < 4.13
  doCheck = lib.versionAtLeast ocaml.version "4.13";

  meta = {
    description = "Pure OCaml implementation of Zlib";
    homepage = "https://github.com/mirage/decompress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "decompress.pipe";
  };
})
