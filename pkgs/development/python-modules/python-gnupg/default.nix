{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, gnupg
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-gnupg";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-VnS61Ok4dsCw0xl+MU1/lC05AYvzHiuDP2eIpoE8P7g=";
=======
    hash = "sha256-cHWOOH/A4MS628s5T2GsvmizSXCo/tfg98iUaf4XkSo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace gnupg.py \
      --replace "gpgbinary='gpg'" "gpgbinary='${gnupg}/bin/gpg'"
    substituteInPlace test_gnupg.py \
      --replace "os.environ.get('GPGBINARY', 'gpg')" "os.environ.get('GPGBINARY', '${gnupg}/bin/gpg')"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # network access
    "test_search_keys"
  ];

  pythonImportsCheck = [ "gnupg" ];

  meta = with lib; {
    description = "API for the GNU Privacy Guard (GnuPG)";
    homepage = "https://github.com/vsajip/python-gnupg";
<<<<<<< HEAD
    changelog = "https://github.com/vsajip/python-gnupg/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ copumpkin ];
  };
}
