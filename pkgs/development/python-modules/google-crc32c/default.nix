{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cffi,
  crc32c,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "google-crc32c";
  version = "1.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-crc32c";
    rev = "refs/tags/v${version}";
    hash = "sha256-uGW4gWIpTVQ+f52WBA9H+K3+sHNa4JdgO9qi1Ds7WEU=";
  };

  buildInputs = [ crc32c ];

  propagatedBuildInputs = [ cffi ];

  LDFLAGS = "-L${crc32c}/lib";
  CFLAGS = "-I${crc32c}/include";

  nativeCheckInputs = [
    pytestCheckHook
    crc32c
  ];

  pythonImportsCheck = [ "google_crc32c" ];

  meta = with lib; {
    homepage = "https://github.com/googleapis/python-crc32c";
    description = "Wrapper the google/crc32c hardware-based implementation of the CRC32C hashing algorithm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ freezeboy ];
  };
}
