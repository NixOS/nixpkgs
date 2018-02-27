{ stdenv, fetchFromGitHub, zlib, perl, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "rdkafka-${version}";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "17ghq0kzk2fdpxhr40xgg3s0p0n0gkvd0d85c6jsww3mj8v5xd14";
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
