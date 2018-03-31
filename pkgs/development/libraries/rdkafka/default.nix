{ stdenv, fetchFromGitHub, zlib, perl, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "rdkafka-${version}";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "11ps8sy4v8yvj4sha7d1q3rmhfw7l1rd52rnl01xam9862yasahs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib perl python ];

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  configureFlags = stdenv.lib.optionals stdenv.isDarwin [ "--disable-ssl" ];

  postPatch = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = https://github.com/edenhill/librdkafka;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ boothead wkennington ];
  };
}
