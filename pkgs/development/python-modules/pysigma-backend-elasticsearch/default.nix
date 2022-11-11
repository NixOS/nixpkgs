{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pysigma-backend-elasticsearch";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-elasticsearch";
    rev = "refs/tags/v${version}";
    hash = "sha256-Niix0j4xaoQBMxvTOhy7hgmZ5btjs+0ovTEJcXAzjNY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  checkInputs = [
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [
    "sigma.backends.elasticsearch"
  ];

  disabledTests = [
    # Tests requires network access
    "test_connect_lucene"
  ];

  meta = with lib; {
    description = "Library to support Elasticsearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-elasticsearch";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
