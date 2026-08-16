{
  lib,
  buildPythonPackage,
  cryptography,
  cython,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "oracledb";
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "python-oracledb";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-xT2PWP6kQ0K+9kxe0vNWY5+kMyKZ1J7toiEZBxfsAGE=";
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
    changelog = "https://github.com/oracle/python-oracledb/blob/${finalAttrs.src.tag}/doc/src/release_notes.rst";
    license = with lib.licenses; [
      asl20 # and or
      upl
    ];
    maintainers = with lib.maintainers; [ harvidsen ];
  };
})
