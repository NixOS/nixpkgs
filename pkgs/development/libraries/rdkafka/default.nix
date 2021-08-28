{ lib, stdenv, fetchFromGitHub, zlib, pkg-config, python3, openssl }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "sha256-EoNzxwuLiYi6sMhyqD/x+ku6BKA+i5og4XsUy2JBN0U=";
  };

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ zlib openssl ];

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
