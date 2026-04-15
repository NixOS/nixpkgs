{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-datafiles";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omarkohl";
    repo = "pytest-datafiles";
    tag = version;
    hash = "sha256-xB96JAUlEicIrTET1L363H8O2JwCTuUWr9jX/70uFvs=";
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_datafiles" ];

  meta = {
    description = "Pytest plugin to create a tmpdir containing predefined files/directories";
    homepage = "https://github.com/omarkohl/pytest-datafiles";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
