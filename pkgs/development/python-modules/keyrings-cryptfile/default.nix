{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, argon2-cffi
, keyring
, pycryptodome
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "keyrings.cryptfile";
  # NOTE: newer releases are bugged/incompatible
  # https://github.com/frispete/keyrings.cryptfile/issues/15
  version = "1.3.4";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jW+cKMm+xef8C+fl0CGe+6SEkYBHDjFX2/kLCZ62j6c=";
  };

  patches = [
    # upstream setup.cfg has an option that is not supported
    ./fix-testsuite.patch
    # change of API in keyrings.testing
    (fetchpatch {
      url = "https://github.com/frispete/keyrings.cryptfile/commit/6fb9e45f559b8b69f7a0a519c0bece6324471d79.patch";
      sha256 = "sha256-1878pMO9Ed1zs1pl+7gMjwx77HbDHdE1CryN8TPfPdU=";
    })
  ];

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
    "test_set_properties"
    "UncryptedFileKeyringTestCase"
  ];

  meta = with lib; {
    description = "Encrypted file keyring backend";
    homepage = "https://github.com/frispete/keyrings.cryptfile";
    license = licenses.mit;
    maintainers = teams.chia.members;
  };
}
