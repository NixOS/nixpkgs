{ lib, stdenv, fetchFromGitHub
, cmake, protobuf, protobufc
, libsodium, openssl
}:

stdenv.mkDerivation rec {
  pname   = "libnats";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner  = "nats-io";
    repo   = "nats.c";
    rev    = "v${version}";
    sha256 = "1ngji3sa44y27lnq4x5dzbd117s9psx4w0j50b4c2b72cf2z139q";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libsodium openssl protobuf protobufc ];

  separateDebugInfo = true;
  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "C API for the NATS messaging system";
    homepage    = "https://github.com/nats-io/nats.c";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
