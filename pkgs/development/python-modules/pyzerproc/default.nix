{ lib
, bleak
, click
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
<<<<<<< HEAD
, pythonAtLeast
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyzerproc";
  version = "0.4.12";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vS0sk/KjDhWispZvCuGlmVLLfeFymHqxwNzNqNRhg6k=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  propagatedBuildInputs = [
    bleak
    click
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

<<<<<<< HEAD
  disabledTestPaths = lib.optionals (pythonAtLeast "3.11") [
    # unittest.mock.InvalidSpecError: Cannot spec a Mock object.
    "tests/test_light.py"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "pyzerproc"
  ];

  meta = with lib; {
    description = "Python library to control Zerproc Bluetooth LED smart string lights";
    homepage = "https://github.com/emlove/pyzerproc";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
