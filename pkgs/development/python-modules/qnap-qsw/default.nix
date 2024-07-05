{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "qnap-qsw";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "python-qnap-qsw";
    rev = version;
    sha256 = "WP1bGt7aAtSVFOMJgPXKqVSbi5zj9K7qoIVrYCrPGqk=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "qnap_qsw" ];

  meta = with lib; {
    description = "Python library to interact with the QNAP QSW API";
    homepage = "https://github.com/Noltari/python-qnap-qsw";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
