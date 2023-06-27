{ lib
, buildPythonPackage
, fetchPypi
, lxml
, six
, xmltodict
}:

buildPythonPackage rec {
  pname = "netapp-lib";
  version = "2021.6.25";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1g4FCSMyS8T6F/T8BOqak4h1nJis8g9jaOluA4FTNpA=";
  };

  propagatedBuildInputs = [
    lxml
    six
    xmltodict
  ];

  # no tests in sdist and no other download available
  doCheck = false;

  pythonImportsCheck = [ "netapp_lib" ];

  meta = with lib; {
    description = "netapp-lib is required for Ansible deployments to interact with NetApp storage systems";
    homepage = "https://netapp.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
