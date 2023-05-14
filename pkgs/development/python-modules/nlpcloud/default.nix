{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "nlpcloud";
  version = "1.0.41";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LtwN1fF/lfvXrB30P0VvuVGnsG8p1ZAalDCYL/a9uGE=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "nlpcloud"
  ];

  meta = with lib; {
    description = "Python client for the NLP Cloud API";
    homepage = "https://nlpcloud.com/";
    changelog = "https://github.com/nlpcloud/nlpcloud-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
