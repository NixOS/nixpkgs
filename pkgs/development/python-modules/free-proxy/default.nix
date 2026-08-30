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
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jundymek";
    repo = "free-proxy";
    tag = "v${version}";
    hash = "sha256-5fvSla4F0epe9XWtvd++RS/IKDTfzgKgU1dYmoZkeZk=";
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
