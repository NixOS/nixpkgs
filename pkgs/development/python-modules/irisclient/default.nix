{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "irisclient";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O0JiAWJKh1qOU4arT6OYyL7tFDopFfKtL8sMmWmTGBY=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  meta = {
    changelog = "https://falcon.readthedocs.io/en/stable/changes/${version}.html";
    description = "Ultra-reliable, fast ASGI+WSGI framework for building data plane APIs at scale";
    homepage = "https://falconframework.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
