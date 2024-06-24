{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "nlpcloud";
  version = "1.1.46";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NmNu1Rf6mN+Q8FdpeNYQ508ksqkIV7oOp8CrlDN1qPU=";
  };

  propagatedBuildInputs = [ requests ];

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
