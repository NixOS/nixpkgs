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
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jundymek";
    repo = "free-proxy";
    tag = "v${version}";
    hash = "sha256-Q8102tnssVnIYEP9fBOBFSSsZqTGGulalyAkvnlp3UY=";
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
