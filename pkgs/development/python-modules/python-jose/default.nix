{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  ecdsa,
  rsa,
  pyasn1,

  # optional-dependencies
  cryptography,
  pycrypto,
  pycryptodome,

  # tests
  pytestCheckHook,
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

  patches = [
    (fetchpatch {
      name = "CVE-2024-33663.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/python-python-jose/CVE-2024-33663.patch?rev=36cd8815411620042f56a3b81599b341";
      hash = "sha256-uxOCa7Lg82zY2nuHzw6CbcymCKUodITrFU3lLY1XMFU=";
    })
    (fetchpatch {
      name = "CVE-2024-33664.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/python-python-jose/CVE-2024-33664.patch?rev=36cd8815411620042f56a3b81599b341";
      hash = "sha256-wx/U1T7t7TloP+dMXxGxEVB3bMC7e6epmN8RE8FKksM=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    ecdsa
    pyasn1
    rsa
  ];

  passthru.optional-dependencies = {
    cryptography = [ cryptography ];
    pycrypto = [ pycrypto ];
    pycryptodome = [ pycryptodome ];
  };

  pythonImportsCheck = [ "jose" ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  disabledTests = [
    # https://github.com/mpdavis/python-jose/issues/348
    "TestBackendEcdsaCompatibility"
  ];

  meta = with lib; {
    changelog = "https://github.com/mpdavis/python-jose/releases/tag/${version}";
    homepage = "https://github.com/mpdavis/python-jose";
    description = "JOSE implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jhhuh ];
  };
}
