{
  lib,
  fetchzip,
  buildDunePackage,
  ocaml,
  odoc,
  matrix,
  toffee,
  cmarkit,
  windtrap,
  ppx_windtrap,
}:

buildDunePackage (finalAttrs: {
  pname = "mosaic";
  # 0.2.0 too fresh/breaking for downstream deps (k7 & console pin matrix < 0.2.0)
  version = "0.1.0";

  src = fetchzip {
    url = "https://github.com/invariant-hq/mosaic/releases/download/${finalAttrs.version}/mosaic-${finalAttrs.version}.tbz";
    hash = "sha256-GzCpU24w9QNiBEa9nAtLcqDxfY75XxfoSE5LLYvUCvA=";
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
    windtrap
    ppx_windtrap
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
