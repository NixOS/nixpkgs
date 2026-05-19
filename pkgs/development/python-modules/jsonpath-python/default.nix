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
  version = "1.1.5";
  pyproject = true;
  src = fetchPypi {
    inherit version;
    pname = "jsonpath_python";
    hash = "sha256-zuou/Z5WrdCTMKLJYx6j1VKXuWGTSMEFXlv7nLC4xTg=";
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
