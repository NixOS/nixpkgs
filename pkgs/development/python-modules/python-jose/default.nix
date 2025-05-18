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
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    tag = version;
    hash = "sha256-rPtOZ25aKIN+g3cyv8n6cNejoj3yKk4zpjdLDyEG1e4=";
  };

  patches = [
    # https://github.com/mpdavis/python-jose/pull/381
    ./cryptography-45.0.patch
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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "jose" ];

  meta = with lib; {
    description = "JOSE implementation in Python";
    homepage = "https://github.com/mpdavis/python-jose";
    changelog = "https://github.com/mpdavis/python-jose/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
