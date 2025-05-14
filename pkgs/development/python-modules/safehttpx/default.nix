{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  httpx,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "safehttpx";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s1a/yCzuOiTDlblKLb6rvtYK/xql+jtf6XxPJFbrzkI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    httpx
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
