{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "nlpcloud";
  version = "1.1.47";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zj6hurPEzNlbrD6trq+zQHBNg4lJMGw+XHV51rBa9Mk=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "nlpcloud" ];

  meta = with lib; {
    description = "Python client for the NLP Cloud API";
    homepage = "https://nlpcloud.com/";
    changelog = "https://github.com/nlpcloud/nlpcloud-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
