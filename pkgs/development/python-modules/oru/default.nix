{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyotp,
  pyppeteer,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oru";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wLD1v98Ez5rexQEvtR7XBiY40I8Lb2X9WzU9kcE5iVY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyotp
    pyppeteer
    requests
  ];

  doCheck = false;

  pythonImportsCheck = [ "oru" ];

  meta = {
    description = "Python client for Orange and Rockland Utility smart energy meters";
    homepage = "https://github.com/bvlaicu/oru";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
