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
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "omarkohl";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-YFD8M5TG6VtLRX04R3u0jtYDDlaK32D4ArWxS6x2b/E=";
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
