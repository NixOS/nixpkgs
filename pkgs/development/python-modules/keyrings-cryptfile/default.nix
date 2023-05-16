{ lib
<<<<<<< HEAD
, argon2-cffi
, buildPythonPackage
, fetchPypi
=======
, buildPythonPackage
, fetchPypi
, fetchpatch
, argon2-cffi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, keyring
, pycryptodome
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "keyrings-cryptfile";
  version = "1.3.9";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "keyrings.cryptfile";
    inherit version;
    hash = "sha256-fCpFPKuZhUJrjCH3rVSlfkn/joGboY4INAvYgBrPAJE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "-s --cov=keyrings/cryptfile" ""
  '';
=======
  pname = "keyrings.cryptfile";
  # NOTE: newer releases are bugged/incompatible
  # https://github.com/frispete/keyrings.cryptfile/issues/15
  version = "1.3.4";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jW+cKMm+xef8C+fl0CGe+6SEkYBHDjFX2/kLCZ62j6c=";
  };

  patches = [
    # upstream setup.cfg has an option that is not supported
    ./fix-testsuite.patch
    # change of API in keyrings.testing
    (fetchpatch {
      url = "https://github.com/frispete/keyrings.cryptfile/commit/6fb9e45f559b8b69f7a0a519c0bece6324471d79.patch";
      hash = "sha256-1878pMO9Ed1zs1pl+7gMjwx77HbDHdE1CryN8TPfPdU=";
    })
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    argon2-cffi
    keyring
    pycryptodome
  ];

  pythonImportsCheck = [
    "keyrings.cryptfile"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
<<<<<<< HEAD
    # FileNotFoundError: [Errno 2] No such file or directory: '/build/...
    "test_versions"
=======
    "test_set_properties"
    "UncryptedFileKeyringTestCase"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Encrypted file keyring backend";
    homepage = "https://github.com/frispete/keyrings.cryptfile";
<<<<<<< HEAD
    changelog = "https://github.com/frispete/keyrings.cryptfile/blob/v${version}/CHANGES.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = teams.chia.members;
  };
}
