{
  lib,
  buildPythonPackage,
  cffi,
  crc32c,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-crc32c";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-crc32c";
    rev = "refs/tags/v${version}";
    hash = "sha256-uGW4gWIpTVQ+f52WBA9H+K3+sHNa4JdgO9qi1Ds7WEU=";
  };

  build-system = [ setuptools ];

  buildInputs = [ crc32c ];

  dependencies = [ cffi ];

  LDFLAGS = "-L${crc32c}/lib";
  CFLAGS = "-I${crc32c}/include";

  nativeCheckInputs = [
    pytestCheckHook
    crc32c
  ];

  pythonImportsCheck = [ "google_crc32c" ];

  meta = with lib; {
    description = "Wrapper the google/crc32c hardware-based implementation of the CRC32C hashing algorithm";
    homepage = "https://github.com/googleapis/python-crc32c";
    changelog = "https://github.com/googleapis/python-crc32c/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ freezeboy ];
  };
}
