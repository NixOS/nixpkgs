{
  lib,
  buildPythonPackage,
  cryptography,
  ecdsa,
  fetchFromGitHub,
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
