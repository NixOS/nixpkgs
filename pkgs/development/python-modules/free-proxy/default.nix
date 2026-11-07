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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jundymek";
    repo = "free-proxy";
    tag = "v${version}";
    hash = "sha256-DUncT4TOFvkr8S8GTXW8h2iYvZIiZZ7T6y+lpGsY8TU=";
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
