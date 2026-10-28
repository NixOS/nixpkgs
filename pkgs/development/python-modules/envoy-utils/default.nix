{
  lib,
  buildPythonPackage,
  fetchPypi,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "envoy-utils";
  version = "0.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "envoy_utils";
    inherit version;
    hash = "sha256-DMQ1srmowqZkUwyFv9EI5L11AAeaobuTppYoMU0D9o8=";
  };

  propagatedBuildInputs = [ zeroconf ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "envoy_utils" ];

  meta = {
    description = "Python utilities for the Enphase Envoy";
    homepage = "https://pypi.org/project/envoy-utils/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
