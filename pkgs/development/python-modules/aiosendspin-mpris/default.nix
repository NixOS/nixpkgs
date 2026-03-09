{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiosendspin,
  mpris-api,

  # meta
  music-assistant,
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

  build-system = [
    setuptools
  ];

  dependencies = [
    aiosendspin
    mpris-api
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "aiosendspin"
  ];

  meta = {
    changelog = "https://github.com/abmantis/aiosendspin-mpris/releases/tag/${finalAttrs.src.tag}";
    description = "MPRIS integration for aiosendspin";
    homepage = "https://github.com/abmantis/aiosendspin-mpris";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fooker ];
  };
})
