{ stdenv, fetchFromGitHub, openssl, doxygen, zlib, pkgconfig, protobuf }:
let
  version = "v0.15";
in
stdenv.mkDerivation {
  name = "ndn-cpp-${version}";
  src = fetchFromGitHub {
    owner = "named-data";
    repo = "ndn-cpp";
    rev = "refs/tags/${version}";
    sha256 = "0vqwdmyj5fqjgax6y831bbvdigmkrzba6i2dvk1xindyc8x7d8nc";
  };
  enableParallelBuilding = true;
  nativeBuildInputs = [ doxygen pkgconfig protobuf ];
  buildInputs = [ openssl zlib ];
  meta = with stdenv.lib; {
    homepage = http://named-data.net/;
    description = "A Named Data Neworking (NDN) client library";
    longDescription = "NDN-CPP is a new implementation of a Named Data Networking client library written in C++ and C.
      It is wire format compatible with the NDN-TLV encoding.";
    license = licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.sjmackenzie ];
  };
}
