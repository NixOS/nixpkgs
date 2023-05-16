{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, morphys
, pytestCheckHook
, pythonOlder
=======
, pytest-runner
, pytestCheckHook
, pythonOlder
, morphys
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, six
, varint
}:

buildPythonPackage rec {
  pname = "py-multicodec";
  version = "0.2.1";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  disabled = pythonOlder "3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
=======
    rev = "v${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hash = "sha256-2aK+bfhqCMqSO+mtrHIfNQmQpQHpwd7yHseI/3O7Sp4=";
  };

  # Error when not substituting:
  # Failed: [pytest] section in setup.cfg files is no longer supported, change to [tool:pytest] instead.
  postPatch = ''
<<<<<<< HEAD
    substituteInPlace setup.cfg \
      --replace "[pytest]" "[tool:pytest]"
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    morphys
    six
    varint
=======
    substituteInPlace setup.cfg --replace "[pytest]" "[tool:pytest]"
  '';

  nativeBuildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    varint
    six
    morphys
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "multicodec"
  ];
=======
  pythonImportsCheck = [ "multicodec" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Compact self-describing codecs";
    homepage = "https://github.com/multiformats/py-multicodec";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
