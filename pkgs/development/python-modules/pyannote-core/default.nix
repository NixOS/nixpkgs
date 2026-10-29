{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  numpy,
  pandas,
  sortedcontainers,

  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyannote-core";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-core";
    tag = finalAttrs.version;
    hash = "sha256-r5NkOAzrQGcb6LPi4/DA0uT9R0ELiYuwQkbT1l6R8Mw=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    numpy
    pandas
    sortedcontainers
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyannote.core" ];

  meta = {
    description = "Advanced data structures for handling temporal segments with attached labels";
    homepage = "https://github.com/pyannote/pyannote-core";
    changelog = "https://github.com/pyannote/pyannote-core/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
