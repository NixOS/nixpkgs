{ lib, stdenv, fetchFromGitHub, zlib, zstd, pkg-config, python3, openssl, which }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "sha256-G6rTvb2Z2O1Df5/6upEB9Eh049sx+LWhhDKvsZdDqsc=";
  };

  nativeBuildInputs = [ pkg-config python3 which ];

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
