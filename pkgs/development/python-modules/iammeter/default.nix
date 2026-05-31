{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "iammeter";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q0o392Xf3cY5BkX4ic6pE3XKMSgek5cpW4TMqSh+Ew8=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "iammeter" ];

  meta = {
    description = "Module to work with the IamMeter API";
    homepage = "https://pypi.org/project/iammeter/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
