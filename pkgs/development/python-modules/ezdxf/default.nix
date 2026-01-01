{
  lib,
<<<<<<< HEAD
  stdenv,
  buildPythonPackage,
=======
  buildPythonPackage,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  withGui ? false,
  qt6,
  librecad,
  gitUpdater,
}:

buildPythonPackage rec {
  version = "1.4.3";
=======
}:

buildPythonPackage rec {
  version = "1.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "ezdxf";

  pyproject = true;

<<<<<<< HEAD
=======
  disabled = pythonOlder "3.5";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-v/xW/Tg3OgzwvSNy3cfkxzf6R33ZvW4VE8k7MB+rM+w=";
  };

  nativeBuildInputs = lib.optionals withGui [ qt6.wrapQtAppsHook ];

=======
    hash = "sha256-BzdLl2GjLh2ABJzJ6bhdbic9jlSABIVR3XGrYiLJHa0=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  dependencies = [
    pyparsing
    typing-extensions
    numpy
    fonttools
<<<<<<< HEAD
  ]
  ++ lib.optionals withGui ([ qt6.qtbase ] ++ optional-dependencies.draw);
=======
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  dontWrapQtApps = true;

  preFixup = lib.optionalString withGui ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  checkInputs = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "ezdxf"
    "ezdxf.addons"
  ];

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    mainProgram = "ezdxf";
    homepage = "https://github.com/mozman/ezdxf/";
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
