{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, loguru
, pytest-asyncio
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
, typing-extensions
=======
, pytest-mypy
, pytestCheckHook
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "python-utils";
<<<<<<< HEAD
  version = "3.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "3.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-WSP5LQQZnm9k0v/xbsUHgQiwmhcb2Uw9BQurC1ieMjI=";
  };

  postPatch = ''
    sed -i pytest.ini \
      -e '/--cov/d' \
      -e '/--mypy/d'
  '';

  propagatedBuildInputs = [
    typing-extensions
  ];

=======
    hash = "sha256-FFBWkq7ct4JWSTH4Ldg+pbG/BAiW33puB7lqFPBjptw=";
  };

  postPatch = ''
    sed -i '/--cov/d' pytest.ini
    sed -i '/--mypy/d' pytest.ini
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.optional-dependencies = {
    loguru = [
      loguru
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
<<<<<<< HEAD
=======
    pytest-mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ] ++ passthru.optional-dependencies.loguru;

  pythonImportsCheck = [
    "python_utils"
  ];

  pytestFlagsArray = [
    "_python_utils_tests"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Flaky tests on darwin
    "test_timeout_generator"
  ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    changelog = "https://github.com/wolph/python-utils/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
