{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  cppo,
  dune-configurator,
  findlib,
  perl,
  ppx_deriving_yojson,
  zarith,
}:

buildDunePackage (finalAttrs: {
  pname = "goblint-cil";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "goblint";
    repo = "cil";
    tag = finalAttrs.version;
    hash = "sha256-EA/ajGwDkRDXlKpDBL1EVBJqmFoLhh/MP8sZEBmyK1Q=";
  };

  buildInputs = [
    dune-configurator
  ];

  nativeBuildInputs = [
    cppo
  ];

  propagatedBuildInputs = [
    findlib
    perl
    ppx_deriving_yojson
    zarith
  ];

  meta = {
    description = "A front-end for the C programming language that facilitates program analysis and transformation";
    homepage = "https://github.com/goblint/cil";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
