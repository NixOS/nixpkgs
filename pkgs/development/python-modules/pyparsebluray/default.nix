{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyparsebluray";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ichunjo";
    repo = "pyparsebluray";
    tag = version;
    hash = "sha256-9G+pf4kZnj5ZkJj8qmymqdxCRVUTfGy3m9iF5BjiCxM=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    description = "Parse and extract binary data from bluray files";
    homepage = "https://github.com/Ichunjo/pyparsebluray";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
