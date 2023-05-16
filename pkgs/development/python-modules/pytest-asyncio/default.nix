{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, flaky
, hypothesis
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-asyncio";
<<<<<<< HEAD
  version = "0.21.1";
=======
  version = "0.20.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Wpo8MpCPGiXrckT2x5/yBYtGlzso/L2urG7yGc7SPkA=";
=======
    hash = "sha256-oq28wJ/Tq4yuQ/98tdzYKDyatpliS0Xcbc6T46ZTP7I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [
    "out"
    "testout"
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  postInstall = ''
    mkdir $testout
    cp -R tests $testout/tests
  '';

  doCheck = false;
  passthru.tests.pytest = callPackage ./tests.nix {};

  pythonImportsCheck = [
    "pytest_asyncio"
  ];

  meta = with lib; {
    description = "Library for testing asyncio code with pytest";
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
<<<<<<< HEAD
    changelog = "https://github.com/pytest-dev/pytest-asyncio/blob/v${version}/docs/source/reference/changelog.rst";
=======
    changelog = "https://github.com/pytest-dev/pytest-asyncio/blob/v${version}/CHANGELOG.rst";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
