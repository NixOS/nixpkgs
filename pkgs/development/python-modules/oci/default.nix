{
  lib,
  buildPythonPackage,
  aiohttp,
  certifi,
  circuitbreaker,
  crc32c,
  cryptography,
  fetchFromGitHub,
  pyjwt,
  python-pkcs11,
  pyopenssl,
  python-dateutil,
  pytz,
  six,
  urllib3,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oci";
  version = "2.192.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-python-sdk";
    tag = "v${version}";
    hash = "sha256-fHs86ecOIvAwHldU8JjTICgzVFv2eIbv4lgLY4R2miU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=78.1.1,<84" setuptools
  '';

  pythonRelaxDeps = [
    "cryptography"
    "pyOpenSSL"
    "python-dateutil"
    "urllib3"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    certifi
    circuitbreaker
    crc32c
    cryptography
    pyjwt
    python-pkcs11
    pyopenssl
    python-dateutil
    pytz
    six
    urllib3
  ];

  # Tests fail: https://github.com/oracle/oci-python-sdk/issues/164
  doCheck = false;

  pythonImportsCheck = [ "oci" ];

  meta = {
    description = "Oracle Cloud Infrastructure Python SDK";
    homepage = "https://github.com/oracle/oci-python-sdk";
    changelog = "https://github.com/oracle/oci-python-sdk/blob/${src.tag}/CHANGELOG.rst";
    license =
      with lib.licenses;
      OR [
        asl20
        upl
      ];
    maintainers = with lib.maintainers; [
      ilian
      FKouhai
    ];
  };
}
