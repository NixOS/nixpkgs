{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "jsonpath-python";
  version = "1.0.6";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3Vvkpy2KKZXD9YPPgr880alUTP2r8tIllbZ6/wc0lmY=";
  };
  build-system = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "jsonpath" ];
  enabledTestPaths = [ "test/test*.py" ];

  meta = with lib; {
    homepage = "https://github.com/sean2077/jsonpath-python";
    description = "More powerful JSONPath implementations in modern python";
    maintainers = with maintainers; [ dadada ];
    license = with licenses; [ mit ];
  };
}
