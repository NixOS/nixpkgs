{ lib, stdenv, fetchFromGitHub, zlib, zstd, pkg-config, python3, openssl }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "sha256-YagvXeusHThUo5/1mMs+r+Nr03vAagdnFMkwX3hJsq4=";
  };

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ zlib zstd openssl ];

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
