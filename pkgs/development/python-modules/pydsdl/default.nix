{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydsdl";
  version = "1.24.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenCyphal";
    repo = "pydsdl";
    tag = version;
    hash = "sha256-NY5l2QMUzzZa9JITC9PF+9vtT8jwBVAIsAKA6L6tXTY=";
  };

  build-system = [ setuptools ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "pydsdl" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "pydsdl/_test.py" ];

  meta = {
    description = "Library to process Cyphal DSDL";
    longDescription = ''
      PyDSDL is a Cyphal DSDL compiler front-end implemented in Python. It accepts
      a DSDL namespace at the input and produces a well-annotated abstract syntax
      tree (AST) at the output, evaluating all constant expressions in the process.
      All DSDL features defined in the Cyphal Specification are supported. The
      library should, in theory, work on any platform and with any Python
      implementation.
    '';
    homepage = "https://pydsdl.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wucke13 ];
  };
}
