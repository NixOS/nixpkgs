{
  lib,
  buildPythonPackage,
  elastic-transport,
  elasticsearch-dsl,
  fetchFromGitHub,
  ply,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "luqum";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jurismarches";
    repo = "luqum";
    rev = "refs/tags/${version}";
    hash = "sha256-lcJCLl0crCl3Y5UlWBMZJR2UtVP96gaJNRxwY9Xn7TM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '--doctest-modules --doctest-glob="test_*.rst" --cov=luqum --cov-branch --cov-report html --no-cov-on-fail' ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ply ];

  nativeCheckInputs = [
    elastic-transport
    elasticsearch-dsl
    pytestCheckHook
  ];

  pythonImportsCheck = [ "luqum" ];

  disabledTestPaths = [
    # Tests require an Elasticsearch instance
    "tests/test_elasticsearch/test_es_integration.py"
    "tests/test_elasticsearch/test_es_naming.py"
  ];

  meta = with lib; {
    description = "Lucene query parser generating ElasticSearch queries";
    homepage = "https://github.com/jurismarches/luqum";
    changelog = "https://github.com/jurismarches/luqum/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
