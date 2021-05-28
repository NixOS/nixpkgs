{ lib, buildPythonPackage, isPy3k, fetchFromGitHub, cffi, crc32c, pytestCheckHook }:

buildPythonPackage rec {
  pname = "google-crc32c";
  version = "1.0.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-crc32c";
    rev = "v${version}";
    sha256 = "0n3ggsxmk1fhq0kz6p5rcj4gypfb05i26fcn7lsawakgl7fzxqyl";
  };

  buildInputs = [ crc32c  ];
  propagatedBuildInputs = [ cffi ];

  LDFLAGS = "-L${crc32c}/lib";
  CFLAGS = "-I${crc32c}/include";

  checkInputs = [ pytestCheckHook crc32c ];
  pythonImportsCheck = [ "google_crc32c" ];

  meta = with lib; {
    homepage = "https://github.com/googleapis/python-crc32c";
    description = "Wrapper the google/crc32c hardware-based implementation of the CRC32C hashing algorithm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ freezeboy ];
  };
}
