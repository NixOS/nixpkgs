{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  tomlkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatch-min-requirements";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlambert03";
    repo = "hatch-min-requirements";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QKO5fVvjSqwY+48Fc8sAiZazrxZ4eBYxzVElHr2lcEA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    tomlkit
  ];

  # As of v0.1.0 all tests attempt to use the network
  doCheck = false;

  pythonImportsCheck = [ "hatch_min_requirements" ];

  meta = {
    description = "Hatchling plugin to create optional-dependencies pinned to minimum versions";
    homepage = "https://github.com/tlambert03/hatch-min-requirements";
    changelog = "https://github.com/tlambert03/hatch-min-requirements/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      samuela
    ];
  };
})
