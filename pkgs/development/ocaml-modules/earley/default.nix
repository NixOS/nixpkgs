{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  version = "3.0.0";
  pname = "earley";
  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-earley";
    tag = finalAttrs.version;
    hash = "sha256-vvw6Fi/6EEgF6gub6U/ZE73K3hMw/QWiMvxC1ttHJe4=";
  };

  buildInputs = [ stdlib-shims ];

  doCheck = true;

  meta = {
    description = "Parser combinators based on Earley Algorithm";
    homepage = "https://github.com/rlepigre/ocaml-earley";
    license = lib.licenses.cecill-b;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "pa_ocaml";
  };
})
