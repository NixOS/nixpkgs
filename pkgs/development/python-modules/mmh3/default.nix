{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mmh3";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oc8lNIuazSKd2kZKCU1hcPR9KFCh/Ldio7YXLSzmyko=";
  };

  pythonImportsCheck = [ "mmh3" ];

  meta = with lib; {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://github.com/hajimes/mmh3";
    changelog = "https://github.com/hajimes/mmh3/blob/v${version}/CHANGELOG.md";
    license = licenses.cc0;
    maintainers = [ ];
  };
}
