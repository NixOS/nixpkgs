{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pyparsing,
  typing-extensions,
  pytestCheckHook,
  setuptools,
  cython,
  numpy,
  fonttools,
  pillow,
  pyside6,
  matplotlib,
  pymupdf,
  pyqt5,
}:

buildPythonPackage rec {
  version = "1.4.3b0";
  pname = "ezdxf";

  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    tag = "v${version}";
    hash = "sha256-TG1q1oWQ+LOZugYsEC9rURR2/rsJ+qMSu7bBU5w4+NA=";
  };

  dependencies = [
    pyparsing
    typing-extensions
    numpy
    fonttools
  ];

  optional-dependencies = {
    draw = [
      pyside6
      matplotlib
      pymupdf
      pillow
    ];
    draw5 = [
      pyqt5
      matplotlib
      pymupdf
      pillow
    ];
  };

  build-system = [
    setuptools
    cython
  ];

  checkInputs = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "ezdxf"
    "ezdxf.addons"
  ];

  meta = with lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    mainProgram = "ezdxf";
    homepage = "https://github.com/mozman/ezdxf/";
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.unix;
  };
}
