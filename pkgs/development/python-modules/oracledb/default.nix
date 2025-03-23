{
  lib,
  buildPythonPackage,
  cryptography,
  cython,
  fetchPypi,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "oracledb";
  version = "2.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y9F+u5X5Ep0KuThstjLJ5mfjvix2cnjMEajkWFRo3jM=";
  };

  build-system = [
    cython
    setuptools
    wheel
  ];

  dependencies = [ cryptography ];

  # Checks need an Oracle database
  doCheck = false;

  pythonImportsCheck = [ "oracledb" ];

  meta = with lib; {
    description = "Python driver for Oracle Database";
    homepage = "https://oracle.github.io/python-oracledb";
    changelog = "https://github.com/oracle/python-oracledb/blob/v${version}/doc/src/release_notes.rst";
    license = with licenses; [
      asl20 # and or
      upl
    ];
    maintainers = with maintainers; [ harvidsen ];
  };
}
