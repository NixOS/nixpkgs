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
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-crc32c";
    tag = "v${version}";
    hash = "sha256-YXXoEXnJckF1kqpLXbIbJEcW+le6aeKyc6Y6xmf0SSw=";
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
