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
  withGui ? false,
  qt6,
  librecad,
  gitUpdater,
}:

buildPythonPackage rec {
  version = "1.4.3";
  pname = "ezdxf";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    tag = "v${version}";
    hash = "sha256-v/xW/Tg3OgzwvSNy3cfkxzf6R33ZvW4VE8k7MB+rM+w=";
  };

  nativeBuildInputs = lib.optionals withGui [ qt6.wrapQtAppsHook ];

  dependencies = [
    pyparsing
    typing-extensions
    numpy
    fonttools
  ]
  ++ lib.optionals withGui ([ qt6.qtbase ] ++ optional-dependencies.draw);

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

  dontWrapQtApps = true;

  preFixup = lib.optionalString withGui ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

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

  # The default updateScript of Python packages does not filter prerelease versions.
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    allowedVersions = "^[0-9]+\\.[0-9]+\\.[0-9]+$";
  };

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
