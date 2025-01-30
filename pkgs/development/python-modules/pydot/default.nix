{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  substituteAll,
  graphviz,
  pytestCheckHook,
  chardet,
  parameterized,
  pythonOlder,
  pyparsing,
}:

buildPythonPackage rec {
  pname = "pydot";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kYDaVAtRs6oJ+/gRQLPt++IxXXeOhYmn0KSmnEEzK64=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ pyparsing ];

  nativeCheckInputs = [
    chardet
    parameterized
    pytestCheckHook
  ];

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      inherit graphviz;
    })
  ];

  pytestFlagsArray = [ "test/test_pydot.py" ];

  pythonImportsCheck = [ "pydot" ];

  meta = {
    description = "Allows to create both directed and non directed graphs from Python";
    homepage = "https://github.com/erocarrera/pydot";
    changelog = "https://github.com/pydot/pydot/blob/v${version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
