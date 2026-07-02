{
  buildPythonPackage,
  fetchPypi,
  hatchling,
  lib,
  pytestCheckHook,
  pytest-benchmark,
}:
buildPythonPackage rec {
  pname = "jsonpath-python";
  version = "1.1.6";
  pyproject = true;
  src = fetchPypi {
    inherit version;
    pname = "jsonpath_python";
    hash = "sha256-3e2ZMrTsQfuHJuCcg6+k5r5hj5OMLbKHzCqBcjxjlnE=";
  };
  build-system = [ hatchling ];
  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
  ]
  ++ pytest-benchmark.optional-dependencies.histogram;
  pythonImportsCheck = [ "jsonpath" ];

  meta = {
    homepage = "https://github.com/sean2077/jsonpath-python";
    description = "More powerful JSONPath implementations in modern python";
    maintainers = with lib.maintainers; [ dadada ];
    license = with lib.licenses; [ mit ];
  };
}
