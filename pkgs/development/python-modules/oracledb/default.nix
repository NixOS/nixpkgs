{
  lib,
  buildPythonPackage,
  cryptography,
  cython,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "oracledb";
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "python-oracledb";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Pwbb+/vzNnliBpcDmOpkkNMVI/cPbJY+yMIKKR6m01w=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    cryptography
    typing-extensions
  ];

  # Checks need an Oracle database
  doCheck = false;

  pythonImportsCheck = [ "oracledb" ];

  meta = {
    description = "Python driver for Oracle Database";
    homepage = "https://oracle.github.io/python-oracledb";
    changelog = "https://github.com/oracle/python-oracledb/blob/${src.tag}/doc/src/release_notes.rst";
    license = with lib.licenses; [
      asl20 # and or
      upl
    ];
    maintainers = with lib.maintainers; [ harvidsen ];
  };
}
