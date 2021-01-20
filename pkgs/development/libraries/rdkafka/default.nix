{ stdenv, fetchFromGitHub, zlib, perl, pkg-config, python, openssl }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "12cc7l5vpxyrm8ca0cpm8sdl54hb8dranal8sz55r9y8igz1q1wb";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zlib perl python openssl ];

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = "https://github.com/edenhill/librdkafka";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ commandodev ];
  };
}
