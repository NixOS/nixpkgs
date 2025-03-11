{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "falcon-cors";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "lwcolton";
    repo = "falcon-cors";
    tag = version;
    hash = "sha256-jlEWP7gXbWfdY4coEIM6NWuBf4LOGbUAFMNvqip/FcA=";
  };

  build-system = [ setuptools ];

  meta = {
    changelog = "https://falcon.readthedocs.io/en/stable/changes/${version}.html";
    description = "Ultra-reliable, fast ASGI+WSGI framework for building data plane APIs at scale";
    homepage = "https://falconframework.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
