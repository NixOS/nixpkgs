{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  py,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-datafiles";
  version = "3.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "omarkohl";
    repo = "pytest-datafiles";
    tag = version;
    hash = "sha256-xB96JAUlEicIrTET1L363H8O2JwCTuUWr9jX/70uFvs=";
  };

  buildInputs = [
    py
    pytest
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_datafiles" ];

  meta = {
    description = "Pytest plugin to create a tmpdir containing predefined files/directories";
    homepage = "https://github.com/omarkohl/pytest-datafiles";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
