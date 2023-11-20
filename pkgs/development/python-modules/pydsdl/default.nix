{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

 buildPythonPackage rec {
  pname = "pydsdl";
  version = "1.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OpenCyphal";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sn7KoJmJbr7Y+N9PAXyhJnts/hW+Gi06nrHj5VIDZMU=";
  };

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  # Module doesn't contain tests
  doCheck = false;

  pythonImportsCheck = [
    "pydsdl"
  ];

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
