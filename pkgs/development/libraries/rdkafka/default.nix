{ stdenv, fetchFromGitHub, zlib, perl, pkgconfig, python, openssl }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "0y4m29wyvhhxb7fap9z07zwgcqlr4ifwynf8a7yp5ldjpzfzxpix";
  };

  nativeBuildInputs = [ pkgconfig ];

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
    maintainers = with maintainers; [ boothead ];
  };
}
