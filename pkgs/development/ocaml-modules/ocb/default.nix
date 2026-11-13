{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "ocb";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = "ocb";
    tag = finalAttrs.version;
    hash = "sha256-LbAeeaPsOGd1w0I5YFrgRyFKKwIkYjMaRo2G1JUEado=";
  };

  meta = {
    homepage = "https://github.com/ocamlpro/ocb";
    description = "OCaml library for SVG badge generation";
    changelog = "https://raw.githubusercontent.com/ocamlpro/ocb/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ redianthus ];
    mainProgram = "ocb";
  };
})
