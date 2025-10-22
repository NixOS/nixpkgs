{
  lib,
  buildPythonPackage,
  cryptography,
  ecdsa,
  fetchFromGitHub,
  fetchpatch,
  pyasn1,
  pycrypto,
  pycryptodome,
  pytestCheckHook,
  rsa,
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

  pythonRelaxDeps = [
    # https://github.com/mpdavis/python-jose/pull/376
    "pyasn1"
  ];

  build-system = [ setuptools ];

  dependencies = [
    ecdsa
    pyasn1
    rsa
  ];

  optional-dependencies = {
    cryptography = [ cryptography ];
    pycrypto = [ pycrypto ];
    pycryptodome = [ pycryptodome ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "jose" ];

  meta = with lib; {
    description = "JOSE implementation in Python";
    homepage = "https://github.com/mpdavis/python-jose";
    changelog = "https://github.com/mpdavis/python-jose/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
