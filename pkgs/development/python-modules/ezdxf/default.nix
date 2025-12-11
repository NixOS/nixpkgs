{
  lib,
  stdenv,
  buildPythonPackage,
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
  librecad,
}:

buildPythonPackage rec {
  version = "1.4.0";
  pname = "ezdxf";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    tag = "v${version}";
    hash = "sha256-p8wvnBIOOcZ8XKPN1b9wsWF9eutSNeeoGSkgLfA/kjQ=";
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

  preCheck = ''
    ln -s "${librecad}/${
      if stdenv.hostPlatform.isDarwin then
        "Applications/LibreCAD.app/Contents/Resources"
      else
        "share/librecad"
    }/fonts" fonts/librecad
  '';

  meta = {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    mainProgram = "ezdxf";
    homepage = "https://ezdxf.mozman.at/";
    changelog = "https://github.com/mozman/ezdxf/blob/${src.rev}/notes/pages/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hodapp ];
    platforms = lib.platforms.unix;
  };
}
