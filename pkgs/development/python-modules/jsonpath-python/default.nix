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
  version = "1.1.4";
  pyproject = true;
  src = fetchPypi {
    inherit version;
    pname = "jsonpath_python";
    hash = "sha256-uz4ThU5IB8B4oVA64th8IRuL/02bQLZFXtWDs7UKf90=";
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
