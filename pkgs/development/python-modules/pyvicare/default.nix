{ lib
, authlib
, buildPythonPackage
, fetchFromGitHub
, pkce
, pytestCheckHook
, pythonOlder
, simplejson
}:

buildPythonPackage rec {
  pname = "pyvicare";
<<<<<<< HEAD
  version = "2.28.1";
=======
  version = "2.27.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "somm15";
    repo = "PyViCare";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-6tyFSKD8Igai9A5wn7vRJdTryy+lv2MkxaskNpCwqV8=";
=======
    hash = "sha256-BLvHZRIHj+HysdGcq51Ry3unbT2BQd7lwslAo9n9SdY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version_config=True," 'version="${version}",' \
      --replace "'setuptools-git-versioning<1.8.0'" ""
  '';

  propagatedBuildInputs = [
    authlib
    pkce
  ];

  nativeCheckInputs = [
    pytestCheckHook
    simplejson
  ];

  pythonImportsCheck = [
    "PyViCare"
  ];

  meta = with lib; {
    description = "Python Library to access Viessmann ViCare API";
    homepage = "https://github.com/somm15/PyViCare";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
