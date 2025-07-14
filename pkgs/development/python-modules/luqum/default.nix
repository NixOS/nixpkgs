{
  lib,
  buildPythonPackage,
  elastic-transport,
  elasticsearch-dsl,
  fetchFromGitHub,
  ply,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "luqum";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jurismarches";
    repo = "luqum";
    tag = version;
    hash = "sha256-X1P7sACcp2yVjW3xWmD88iDT4T9dSDi8yxwDFaRbEsc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '--doctest-modules --doctest-glob="test_*.rst"' ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ply ];

  nativeCheckInputs = [
    elastic-transport
    elasticsearch-dsl
    pytestCheckHook
    pytest-cov-stub
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
    changelog = "https://github.com/jurismarches/luqum/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
