{
  lib,
  aiosendspin,
  buildPythonPackage,
  fetchFromGitHub,
  mpris-api,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosendspin-mpris";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = "aiosendspin-mpris";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hOF6rTm0pppk+J7tTVaLDK5C1ofGXz1YU6RVGm92geQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiosendspin
    mpris-api
  ];

  pythonImportsCheck = [ "aiosendspin_mpris" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "MPRIS integration for aiosendspin";
    homepage = "https://github.com/abmantis/aiosendspin-mpris";
    changelog = "https://github.com/abmantis/aiosendspin-mpris/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
