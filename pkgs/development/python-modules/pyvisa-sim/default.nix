{
  lib,
  fetchPypi,
  pythonOlder,
  buildPythonPackage,
  pyvisa,
  pyyaml,
  stringparser,
  typing-extensions,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyvisa-sim";
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyvisa_sim";
    inherit version;
    hash = "sha256-EbEGWOIVJwjuraDIZifYlMTRFIQxLwLTzzhRlrS8hw8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyvisa
    pyyaml
    stringparser
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyvisa_sim" ];

  # should be fixed after 0.5.1, remove at next release
  disabledTestPaths = [ "pyvisa_sim/testsuite/test_all.py" ];

  meta = with lib; {
    description = "Simulated backend for PyVISA implementing TCPIP, GPIB, RS232, and USB resources";
    homepage = "https://pyvisa.readthedocs.io/projects/pyvisa-sim/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
