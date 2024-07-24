{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pip-chill,
  lxml,
  requests,
}:

buildPythonPackage rec {
  pname = "free-proxy";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jundymek";
    repo = "free-proxy";
    rev = "refs/tags/${version}";
    hash = "sha256-82usyhUzZrdYir8puiAfaF650f0PxYJSXBE75zxYjK8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pip-chill
    lxml
    requests
  ];

  meta = {
    description = "Free proxy scraper written in python";
    homepage = "https://github.com/jundymek/free-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
