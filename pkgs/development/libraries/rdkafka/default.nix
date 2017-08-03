{ stdenv, fetchFromGitHub, zlib, perl, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "rdkafka-${version}";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "0yp8vmj3yc564hcmhx46ssyn8qayywnsrg4wg67qk6jw967qgwsn";
  };

  buildInputs = [ zlib perl pkgconfig python ];

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
