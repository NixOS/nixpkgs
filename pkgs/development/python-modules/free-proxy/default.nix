{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  lxml,
  requests,
}:

buildPythonPackage rec {
  pname = "free-proxy";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jundymek";
    repo = "free-proxy";
    tag = "v${version}";
    hash = "sha256-DKeeVfZaDaJg9kwnjFQPhfx4ayebrqJiQmpZjgmeR0c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    requests
  ];

  pythonRemoveDeps = [
    "pip-chill"
  ];

  meta = {
    description = "Free proxy scraper written in python";
    homepage = "https://github.com/jundymek/free-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
