{ lib, buildPythonPackage, fetchFromGitHub, cffi, crc32c, pytestCheckHook }:

buildPythonPackage rec {
  pname = "google-crc32c";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-crc32c";
    rev = "v${version}";
    sha256 = "058g69yp7x41mv0d84yp31jv64fpm4r25b86rvvqgc6n74w6jj7k";
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
