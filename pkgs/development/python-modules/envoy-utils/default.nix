{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "envoy-utils";
  version = "0.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "envoy_utils";
    inherit version;
    hash = "sha256-DMQ1srmowqZkUwyFv9EI5L11AAeaobuTppYoMU0D9o8=";
  };

  propagatedBuildInputs = [ zeroconf ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "envoy_utils" ];

  meta = with lib; {
    description = "Python utilities for the Enphase Envoy";
    homepage = "https://pypi.org/project/envoy-utils/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
