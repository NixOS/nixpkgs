{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  qcheck-core,
}:

buildDunePackage (finalAttrs: {
  pname = "bwd";
  version = "2.3.0";

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "ocaml-bwd";
    rev = finalAttrs.version;
    hash = "sha256-rzn0U/D6kPNsH5hBTElc3d1jfKbgKbjA2JHicpaJtu4=";
  };

  doCheck = true;
  checkInputs = [ qcheck-core ];

  meta = {
    description = "Backward Lists";
    homepage = "https://github.com/RedPRL/ocaml-bwd";
    changelog = "https://github.com/RedPRL/ocaml-bwd/blob/${finalAttrs.version}/CHANGELOG.markdown";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
