{ lib
, buildPythonPackage
, fetchPypi
, distlib
, pythonOlder
, exceptiongroup
, hatch-vcs
, hatchling
, cattrs
, cmake
<<<<<<< HEAD
, ninja
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, pathspec
, pyproject-metadata
, pytest-subprocess
, pytestCheckHook
<<<<<<< HEAD
, setuptools
, tomli
, wheel
=======
, tomli
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "scikit-build-core";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    pname = "scikit_build_core";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-pCqVAps0tc+JKFU0LZuURcd0y3l/yyTI/EwvtCsY38o=";
=======
    hash = "sha256-0qdtlEekEgONxeJd0lmwPCUnhmGgx8Padmu5ccGprNI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'minversion = "7.2"' "" \
      --replace '"error",' '"error", "ignore::DeprecationWarning", "ignore::UserWarning",'
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
    tomli
  ];

  passthru.optional-dependencies = {
    pyproject = [
      distlib
      pathspec
      pyproject-metadata
    ];
  };

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    cattrs
    cmake
<<<<<<< HEAD
    ninja
    pytest-subprocess
    pytestCheckHook
    setuptools
    wheel
=======
    pytest-subprocess
    pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ passthru.optional-dependencies.pyproject;

  disabledTestPaths = [
    # runs pip, requires network access
<<<<<<< HEAD
    "tests/test_custom_modules.py"
    "tests/test_pyproject_pep517.py"
    "tests/test_pyproject_pep518.py"
    "tests/test_pyproject_pep660.py"
=======
    "tests/test_pyproject_pep517.py"
    "tests/test_pyproject_pep518.py"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "tests/test_setuptools_pep517.py"
    "tests/test_setuptools_pep518.py"
  ];

  pythonImportsCheck = [
    "scikit_build_core"
  ];

  meta = with lib; {
    description = "A next generation Python CMake adaptor and Python API for plugins";
    homepage = "https://github.com/scikit-build/scikit-build-core";
<<<<<<< HEAD
    changelog = "https://github.com/scikit-build/scikit-build-core/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
