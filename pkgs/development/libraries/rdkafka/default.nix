{ stdenv, fetchFromGitHub, zlib, perl, pkgconfig, python, openssl }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "03h4yxnbnig17zapnnyvvnh1bsp0qalvlpb4fc3bpvs7yj4d8v25";
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
    homepage = https://github.com/edenhill/librdkafka;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ boothead ];
  };
}
