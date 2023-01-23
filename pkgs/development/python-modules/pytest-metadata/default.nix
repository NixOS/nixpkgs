{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-metadata";
  version = "2.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pytest_metadata";
    inherit version;
    hash = "sha256-/MZT9l/jA1tHiCC1KE+/D1KANiLuP2Ci+u16fTuh9B4=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Plugin for accessing test session metadata";
    homepage = "https://github.com/pytest-dev/pytest-metadata";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
