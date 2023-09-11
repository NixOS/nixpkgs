{ lib
, argon2-cffi
, buildPythonPackage
, fetchPypi
, keyring
, pycryptodome
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
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
    # FileNotFoundError: [Errno 2] No such file or directory: '/build/...
    "test_versions"
  ];

  meta = with lib; {
    description = "Encrypted file keyring backend";
    homepage = "https://github.com/frispete/keyrings.cryptfile";
    changelog = "https://github.com/frispete/keyrings.cryptfile/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = teams.chia.members;
  };
}
