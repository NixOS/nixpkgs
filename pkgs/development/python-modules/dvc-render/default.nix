{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, flatten-dict
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, funcy
, matplotlib
, tabulate
, pytestCheckHook
, pytest-mock
, pytest-test-utils
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dvc-render";
<<<<<<< HEAD
  version = "0.5.3";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-4nqImAYk4pYXSuE2/znzwjtf0349bydqi4iN69wG080=";
=======
    hash = "sha256-bt2jqjhgtGmJsyfYNSzETQZUHFKni/poyeqpQzIJX08=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    table = [
<<<<<<< HEAD
      flatten-dict
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      tabulate
    ];
    markdown = [
      tabulate
      matplotlib
    ];
  };

  nativeCheckInputs = [
    funcy
    pytestCheckHook
    pytest-mock
    pytest-test-utils
  ]
  ++ passthru.optional-dependencies.table
  ++ passthru.optional-dependencies.markdown;

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/test_vega.py"
  ];

  pythonImportsCheck = [
    "dvc_render"
  ];

  meta = with lib; {
    description = "Library for rendering DVC plots";
    homepage = "https://github.com/iterative/dvc-render";
    changelog = "https://github.com/iterative/dvc-render/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
