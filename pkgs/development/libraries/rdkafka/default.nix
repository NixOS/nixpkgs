{ stdenv, fetchFromGitHub, zlib, perl }:

stdenv.mkDerivation rec {
  name = "rdkafka-${version}";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = version;
    sha256 = "0qx5dnq9halqaznmbwg44p1wl64pzl485r4054569rbx9y9ak1zy";
  };

  buildInputs = [ zlib perl ];

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
