{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  httpx2,
}:

buildPythonPackage rec {
  pname = "safehttpx";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vWmKWhcwd3BAzP2sCu96e9sQ9ZkxeWxMmcAD3JDf8oE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    httpx2
  ];

  pythonImportsCheck = [ "safehttpx" ];

  doCheck = false; # require network access

  meta = {
    description = "SSRF-safe wrapper around httpx";
    homepage = "https://github.com/gradio-app/safehttpx";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fliegendewurst ];
  };
}
