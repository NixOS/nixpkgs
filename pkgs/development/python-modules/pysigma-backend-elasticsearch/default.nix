{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-elasticsearch";
  version = "1.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-elasticsearch";
    rev = "refs/tags/v${version}";
    hash = "sha256-qIP+TP6lzviEAunYge/SIZQ6PI0EFnJo64FVpPmkdLY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=sigma --cov-report term --cov-report xml:cov.xml" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "sigma.backends.elasticsearch" ];

  disabledTests = [
    # Tests requires network access
    "test_connect_lucene"
    # AssertionError
    "correlation_rule_stats"
  ];

  meta = with lib; {
    description = "Library to support Elasticsearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-elasticsearch";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-elasticsearch/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
