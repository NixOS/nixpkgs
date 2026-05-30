{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  menhir,
  menhirLib,
  uutf,
}:

buildDunePackage (finalAttrs: {
  pname = "otoml";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = "otoml";
    tag = finalAttrs.version;
    hash = "sha256-e9Bqd6KHorglLMzvsjakyYt/CLZR3yI/yZPl/rnbkDE=";
  };

  # Compatibility with menhir ≥ 20260122
  patches = [ ./menhir.patch ];

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = [
    menhirLib
    uutf
  ];

  meta = {
    description = "TOML parsing and manipulation library for OCaml";
    changelog = "https://github.com/dmbaturin/otoml/raw/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/dmbaturin/otoml/";
  };
})
