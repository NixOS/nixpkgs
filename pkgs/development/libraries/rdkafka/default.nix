{ lib, stdenv, fetchFromGitHub, zlib, perl, pkg-config, python, openssl }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "sha256-VCGR0Q8FcoDLr+CFTk/OLMI4zs87K/IdZS1ANmkeb4s=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zlib perl python openssl ];

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = "https://github.com/edenhill/librdkafka";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ commandodev ];
  };
}
