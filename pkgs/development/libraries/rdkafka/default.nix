{ stdenv, fetchFromGitHub, zlib, perl }:

stdenv.mkDerivation rec {
  name = "rdkafka-${version}";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = version;
    sha256 = "0iklvslz35dd0lz26ffrbfb20qirl9v5kcdmlcnnzc034hr2zmnv";
  };

  buildInputs = [ zlib perl ];

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = "https://github.com/edenhill/librdkafka";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ boothead wkennington ];
  };
}
