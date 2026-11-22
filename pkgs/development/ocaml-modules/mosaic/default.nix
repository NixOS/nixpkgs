{
  lib,
  fetchzip,
  buildDunePackage,
  ocaml,
  odoc,
  matrix,
  toffee,
  cmarkit,
  ppx_windtrap,
  thumper,
  windtrap,
}:

buildDunePackage (finalAttrs: {
  pname = "mosaic";
  version = "0.2.0";

  src = fetchzip {
    url = "https://github.com/invariant-hq/mosaic/releases/download/${finalAttrs.version}/mosaic-${finalAttrs.version}.tbz";
    hash = "sha256-HiOjNCNIFXkQHAQ8d3XZadg95nE231B+4pGVUX3ysUU=";
  };

  minimalOCamlVersion = "5.4";

  nativeBuildInputs = [
    odoc
  ];

  propagatedBuildInputs = [
    matrix
    toffee
    cmarkit
  ];

  checkInputs = [
    ppx_windtrap
    thumper
    windtrap
  ];

  doCheck = true;

  meta = {
    description = "Terminal UI framework for OCaml with The Elm Architecture";
    license = lib.licenses.isc;
    homepage = "https://github.com/invariant-hq/mosaic";
    changelog = "https://raw.githubusercontent.com/invariant-hq/mosaic/refs/tags/${finalAttrs.version}/CHANGES.md";
    maintainers = with lib.maintainers; [
      toastal
    ];
    platforms = lib.filter (p: (lib.systems.elaborate p).parsed.cpu.bits >= 64) ocaml.meta.platforms;
  };
})
