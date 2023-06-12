{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "nlpcloud";
  version = "1.0.42";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XT3aadYrdYZk8EEkUTdFtTMR1LociO0jQo/QCFcJcWw=";
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
