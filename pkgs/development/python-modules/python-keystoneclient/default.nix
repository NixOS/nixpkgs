{ lib
, buildPythonPackage
, fetchPypi
, keystoneauth1
, oslo-config
, oslo-i18n
, oslo-serialization
, pbr
}:
let 
  pyModuleDeps = [
    keystoneauth1
    oslo-config
    oslo-i18n
    oslo-serialization
    pbr
  ];
in
buildPythonPackage rec {
  pname = "python-keystoneclient";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06yb75maw066d1zpgzcwjrz8xgf25fj8ncrxcwhdp92q2c19k6vv";
  };
  
  propagatedBuildInputs = pyModuleDeps;
  
  # Needs internet connection
  doCheck = false;

  meta = with lib; {
    description = "Client Library for OpenStack Identity";
    license = licenses.asl20;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
