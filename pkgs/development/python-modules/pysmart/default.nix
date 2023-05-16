{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, chardet
, humanfriendly
, pytestCheckHook
, pythonOlder
, setuptools-scm
, smartmontools
=======
, smartmontools
, humanfriendly
, pytestCheckHook
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pysmart";
<<<<<<< HEAD
  version = "1.2.5";
  format = "pyproject";
=======
  version = "1.2.3";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-NqE7Twl1kxXrASyxw35xIOTB+LThU0a45NCxh8SUxfI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

=======
    rev = "refs/tags/v${version}";
    hash = "sha256-5VoZEgHWmHUDkm2KhBP0gfmhOJUYJUqDLWBp/kU1404=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    substituteInPlace pySMART/utils.py \
      --replace "which('smartctl')" '"${smartmontools}/bin/smartctl"'
  '';

  propagatedBuildInputs = [
<<<<<<< HEAD
    chardet
    humanfriendly
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

=======
    humanfriendly
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pySMART"
  ];

  meta = with lib; {
    description = "Wrapper for smartctl (smartmontools)";
    homepage = "https://github.com/truenas/py-SMART";
    changelog = "https://github.com/truenas/py-SMART/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
