<<<<<<< HEAD
{ lib
, base58
, buildPythonPackage
, fetchFromGitHub
, morphys
=======
{ base58
, buildPythonPackage
, fetchFromGitHub
, lib
, morphys
, pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
, six
, varint
}:

buildPythonPackage rec {
  pname = "py-multihash";
  version = "2.0.1";
<<<<<<< HEAD
  format = "setuptools";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-z1lmSypGCMFWJNzNgV9hx/IStyXbpd5jvrptFpewuOA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';
=======
    rev = "v${version}";
    hash = "sha256-z1lmSypGCMFWJNzNgV9hx/IStyXbpd5jvrptFpewuOA=";
  };

  nativeBuildInputs = [
    pytest-runner
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    base58
    morphys
    six
    varint
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "multihash"
  ];
=======
  pythonImportsCheck = [ "multihash" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Self describing hashes - for future proofing";
    homepage = "https://github.com/multiformats/py-multihash";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
