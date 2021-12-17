{ lib, buildPythonPackage, fetchFromGitHub, cffi, crc32c, pytestCheckHook }:

buildPythonPackage rec {
  pname = "google-crc32c";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-crc32c";
    rev = "v${version}";
    sha256 = "005ra4pfv71rq53198k7q6k63f529q3g6hkbxbwfcf82jr77hxga";
  };

  buildInputs = [ crc32c ];

  propagatedBuildInputs = [ cffi ];

  LDFLAGS = "-L${crc32c}/lib";
  CFLAGS = "-I${crc32c}/include";

  checkInputs = [ pytestCheckHook crc32c ];

  pythonImportsCheck = [ "google_crc32c" ];

  meta = with lib; {
    homepage = "https://github.com/googleapis/python-crc32c";
    description = "Wrapper the google/crc32c hardware-based implementation of the CRC32C hashing algorithm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ freezeboy SuperSandro2000 ];
  };
}
