{ stdenv, fetchFromGitHub, zlib, perl, pkgconfig, python, openssl }:

stdenv.mkDerivation rec {
  name = "rdkafka-${version}";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "17fah3x71ipnzvlj0yg8hfmqkk91s942z34p681r4k8giv7avm30";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib perl python openssl ];

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = https://github.com/edenhill/librdkafka;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ boothead ];
  };
}
