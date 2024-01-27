{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, ecdsa
, rsa
, pyasn1

# optional-dependencies
, cryptography
, pycrypto
, pycryptodome

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = pname;
    rev = version;
    hash = "sha256-6VGC6M5oyGCOiXcYp6mpyhL+JlcYZKIqOQU9Sm/TkKM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ecdsa
    pyasn1
    rsa
  ];

  passthru.optional-dependencies = {
    cryptography = [
      cryptography
    ];
    pycrypto = [
      pycrypto
    ];
    pycryptodome = [
      pycryptodome
    ];
  };

  pythonImportsCheck = [
    "jose"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/mpdavis/python-jose/releases/tag/${version}";
    homepage = "https://github.com/mpdavis/python-jose";
    description = "A JOSE implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jhhuh ];
  };
}
