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
    sha256 = "13zn0d6k2a4nls9vp8cs0w07bgg4138vz18cadjadhm8p6r3bi0c";
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
