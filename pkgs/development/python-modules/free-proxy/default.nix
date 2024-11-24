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
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jundymek";
    repo = "free-proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-8SxKGGifQTU0CUrtUQUtrmeq+Do4GIqNUWAdCt++eUA=";
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
