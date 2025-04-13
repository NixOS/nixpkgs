{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-repeat";
  version = "0.9.4";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_repeat";
    inherit version;
    hash = "sha256-2SrBTfqm/8/mkX5dFvDJvII4DBNbA8Kl9BLSY38iRIU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_repeat" ];

  meta = with lib; {
    description = "Pytest plugin for repeating tests";
    homepage = "https://github.com/pytest-dev/pytest-repeat";
    changelog = "https://github.com/pytest-dev/pytest-repeat/blob/v${version}/CHANGES.rst";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
