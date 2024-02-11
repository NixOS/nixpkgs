{ lib
, fetchPypi
, pythonOlder
, buildPythonPackage
, pyvisa
, pyyaml
, stringparser
, typing-extensions
, pytestCheckHook
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "pyvisa-sim";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "PyVISA-sim";
    inherit version;
    hash = "sha256-kHahaRKoEUtDxEsdMolPwfEy1DidiytxmvYiQeQhYcE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    pyvisa
    pyyaml
    stringparser
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyvisa_sim" ];

  # should be fixed after 0.5.1, remove at next release
  disabledTestPaths = [
    "pyvisa_sim/testsuite/test_all.py"
  ];

  meta = with lib; {
    description = "Simulated backend for PyVISA implementing TCPIP, GPIB, RS232, and USB resources";
    homepage = "https://pyvisa.readthedocs.io/projects/pyvisa-sim/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
