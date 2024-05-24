{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "iammeter";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q0o392Xf3cY5BkX4ic6pE3XKMSgek5cpW4TMqSh+Ew8=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "iammeter" ];

  meta = with lib; {
    description = "Module to work with the IamMeter API";
    homepage = "https://pypi.org/project/iammeter/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
