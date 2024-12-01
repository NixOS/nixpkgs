{
  lib,
  buildPythonPackage,
  fetchPypi,
  networkx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "importlab";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s4k4U7H26wJ9pQnDtA5nh+ld1mtLZvGzYTqtd1VuFGU=";
  };

  propagatedBuildInputs = [ networkx ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/test_parsepy.py" ];

  # Test fails on darwin filesystem
  disabledTests = [ "testIsDir" ];

  pythonImportsCheck = [ "importlab" ];

  meta = with lib; {
    description = "Library that automatically infers dependencies for Python files";
    mainProgram = "importlab";
    homepage = "https://github.com/google/importlab";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
  };
}
