{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "qnap-qsw";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "qnap-qsw";
    hash = "sha256-A3yam3amuvk7LJrN3IPXWAca2oZAJMHLe2dx0sQEK3c=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "qnap_qsw" ];

  meta = {
    description = "Python library to interact with the QNAP QSW API";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
