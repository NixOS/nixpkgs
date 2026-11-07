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
  pyopenssl,
  python-dateutil,
  python-pkcs11,
  pytz,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "oci";
  version = "2.190.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-python-sdk";
    tag = "v${version}";
    hash = "sha256-FaKjwSV+d1+Syv8OwbDTRUJK8JYf7MJZGcZVv5STtvE=";
  };

  postPatch = ''
    sed -Ei 's/(setuptools)[<>=!~][^"]*/\1/' pyproject.toml
  '';

  pythonRelaxDeps = [
    "cryptography"
    "pyOpenSSL"
    "python-dateutil"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    certifi
    circuitbreaker
    crc32c
    cryptography
    pyjwt
    pyopenssl
    python-dateutil
    python-pkcs11
    pytz
    urllib3
    six
  ];

  # Tests fail: https://github.com/oracle/oci-python-sdk/issues/164
  doCheck = false;

  pythonImportsCheck = [ "oci" ];

  meta = {
    description = "Oracle Cloud Infrastructure Python SDK";
    homepage = "https://github.com/oracle/oci-python-sdk";
    changelog = "https://github.com/oracle/oci-python-sdk/blob/${src.tag}/CHANGELOG.rst";
    license = with lib.licenses; [
      asl20 # or
      upl
    ];
    maintainers = with lib.maintainers; [
      ilian
    ];
  };
}
