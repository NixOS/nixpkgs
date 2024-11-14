{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydsdl";
  version = "1.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenCyphal";
    repo = "pydsdl";
    rev = "refs/tags/${version}";
    hash = "sha256-Q6Zt7qiFZvTK2pF4nWfHbjwQHZffzKOad6X/HQ94EUo=";
  };

  build-system = [ setuptools ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "pydsdl" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "pydsdl/_test.py" ];

  meta = with lib; {
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
    license = licenses.mit;
    maintainers = with maintainers; [ wucke13 ];
  };
}
