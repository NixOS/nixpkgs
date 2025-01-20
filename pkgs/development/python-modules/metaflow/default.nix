{
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pip,
  pythonOlder,
  requests,
  setuptools,
  twine,
  wheel,
}:

buildPythonPackage rec {
  pname = "metaflow";
  version = "2.12.39";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "metaflow";
    rev = "refs/tags/${version}";
    hash = "sha256-f7+NAy3zlAHvJqROwV7kl1o+/OIGzc5Rsz6A73lUibo=";
  };

  dependencies = [
    boto3
    requests
  ];

  build-system = [
    pip
    setuptools
    wheel
    twine
  ];

  # Uses tox which tries to install dependencies with pip
  doCheck = false;

  pythonImportsCheck = [ "metaflow" ];

  meta = {
    description = "Open Source AI/ML Platform";
    homepage = "https://metaflow.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Echoz ];
  };
}
