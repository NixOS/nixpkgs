{ lib
, buildPythonPackage
, fetchFromGitHub
, py
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-datafiles";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "omarkohl";
    repo = pname;
    rev = version;
    sha256 = "sha256-M0Lnsqi05Xs0uN6LlafNS7HJZOut+nrMZyvGPMMhIkc=";
  };

  buildInputs = [
    py
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_datafiles"
  ];

  meta = with lib; {
    description = "Pytest plugin to create a tmpdir containing predefined files/directories";
    homepage = "https://github.com/omarkohl/pytest-datafiles";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
