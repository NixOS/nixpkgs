{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  menhir,
  menhirLib,
  uutf,
}:

buildDunePackage rec {
  pname = "otoml";
  version = "1.0.5";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = pname;
    rev = version;
    sha256 = "sha256-e9Bqd6KHorglLMzvsjakyYt/CLZR3yI/yZPl/rnbkDE=";
  };

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = [
    menhirLib
    uutf
  ];

  meta = {
    description = "TOML parsing and manipulation library for OCaml";
    changelog = "https://github.com/dmbaturin/otoml/raw/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
