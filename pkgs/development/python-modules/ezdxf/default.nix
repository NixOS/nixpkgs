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
  version = "1.4.3b3";
  pname = "ezdxf";

  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    tag = "v${version}";
    hash = "sha256-xNYpmQpsWIH+kQbb8njYtSdSq3zw4rrGECzk0qPWT7U=";
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

  meta = {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    mainProgram = "ezdxf";
    homepage = "https://github.com/mozman/ezdxf/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hodapp ];
    platforms = lib.platforms.unix;
  };
}
