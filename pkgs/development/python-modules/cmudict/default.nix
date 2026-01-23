{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  importlib-resources,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cmudict";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prosegrinder";
    repo = "python-cmudict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pOqzezrDlwlVsvBHreHmLKxYKDxllZNs0TgLwxBhy58=";
    fetchSubmodules = true;
  };

  build-system = [ poetry-core ];

  dependencies = [
    importlib-metadata
    importlib-resources
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cmudict" ];

  meta = {
    description = "Python wrapper package for The CMU Pronouncing Dictionary data files";
    homepage = "https://github.com/prosegrinder/python-cmudict";
    changelog = "https://github.com/prosegrinder/python-cmudict/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
})
