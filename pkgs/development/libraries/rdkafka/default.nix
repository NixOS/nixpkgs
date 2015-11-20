{ stdenv, fetchFromGitHub, zlib, perl }:

stdenv.mkDerivation rec {
  name = "rdkafka-2015-11-03";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "3e1babf4f26a7d12bbd272c1cdf4aa6a44000d4a";
    sha256 = "1vmbbkgdwxr25wz60hi6rhqb843ipz34r9baygv87fwh3lwwkqwl";
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
