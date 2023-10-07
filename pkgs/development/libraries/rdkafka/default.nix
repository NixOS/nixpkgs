{ lib, stdenv, fetchFromGitHub, zlib, zstd, pkg-config, python3, openssl, which }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "sha256-v/FjnDg22ZNQHmrUsPvjaCs4UQ/RPAxQdg9i8k6ba/4=";
  };

  nativeBuildInputs = [ pkg-config python3 which ];

  buildInputs = [ zlib zstd openssl ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = "https://github.com/confluentinc/librdkafka";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ commandodev ];
  };
}
