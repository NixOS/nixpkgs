{ lib,
  fetchPypi,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  lxml,
  requests,
}:

buildPythonPackage rec {
  pname = "free-proxy";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jundymerk";
    repo = "free-proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-1hTOMbsL1089/yPZbAIs5OgjtEzCBlFv2hGi+u4hV/k=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
