{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  aiohttp,
  requests,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "brunt";
  version = "1.2.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e704627dc7b9c0a50c67ae90f1d320b14f99f2b2fc9bf1ef0461b141dcf1bce9";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  # tests require Brunt hardware
  doCheck = false;

  pythonImportsCheck = [ "brunt" ];

  meta = {
    description = "Unofficial Python SDK for Brunt";
    homepage = "https://github.com/eavanvalkenburg/brunt-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
