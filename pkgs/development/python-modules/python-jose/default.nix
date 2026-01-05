{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  fetchpatch,
  pycrypto,
  pycryptodome,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    tag = version;
    hash = "sha256-8DQ0RBQ4ZgEIwcosgX3dzr928cYIQoH0obIOgk0+Ozs=";
  };

  patches = [
    # https://github.com/mpdavis/python-jose/pull/393
    (fetchpatch {
      name = "fix-test_incorrect_public_key_hmac_signing.patch";
      url = "https://github.com/mpdavis/python-jose/commit/7c0e4c6640bdc9cd60ac66d96d5d90f4377873db.patch";
      hash = "sha256-bCzxZEWKYD20TLqzVv6neZlpU41otbVqaXc7C0Ky9BQ=";
    })
  ];

  pythonRemoveDeps = [
    # These aren't needed if the cryptography backend is used:
    # https://github.com/mpdavis/python-jose/blob/3.5.0/README.rst#cryptographic-backends
    "ecdsa"
    "pyasn1"
    "rsa"
  ];

  build-system = [ setuptools ];

  dependencies = [
    cryptography
  ];

  optional-dependencies = {
    cryptography = [ cryptography ];
    pycrypto = [ pycrypto ];
    pycryptodome = [ pycryptodome ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "jose" ];

  meta = with lib; {
    description = "JOSE implementation in Python";
    homepage = "https://github.com/mpdavis/python-jose";
    changelog = "https://github.com/mpdavis/python-jose/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
