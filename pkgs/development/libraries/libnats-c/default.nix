{ lib, stdenv, fetchFromGitHub
, cmake, protobuf, protobufc
, libsodium, openssl
}:

stdenv.mkDerivation rec {
  pname   = "libnats";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner  = "nats-io";
    repo   = "nats.c";
    rev    = "v${version}";
    sha256 = "sha256-2z+r0OIVYE7NPQQAd5vOK8KkFo4Zzi2pPcwPByJTyPc=";
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
