{ stdenv, fetchFromGitHub, zlib, perl, pkgconfig, python, openssl }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "1daikjr2wcjxcys41hfw3vg2mqk6cy297pfcl05s90wnjvd7fkqk";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib perl python openssl ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = https://github.com/edenhill/librdkafka;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ boothead ];
  };
}
