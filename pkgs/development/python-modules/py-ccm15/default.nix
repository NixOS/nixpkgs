{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  httpx,
  xmltodict,
  aiohttp,
}:

buildPythonPackage {
  pname = "py-ccm15";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ocalvo";
    repo = "py-ccm15";
    # Upstream does not have a tag for this release and this is the exact release commit
    # Therefore it should not be marked unstable
    # upstream issue: https://github.com/ocalvo/py-ccm15/issues/10
    rev = "3891d840e69d241c85bf9486e7fe0bb3c7443980";
    hash = "sha256-I2/AdG07PAvuC8rQKOIAUk7u3pJpANMaFpvEsejWeBU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    xmltodict
    aiohttp
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ccm15" ];

  meta = {
    description = "Python Library to access a Midea CCM15 data converter";
    homepage = "https://github.com/ocalvo/py-ccm15";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
