{ lib, stdenv, fetchFromGitHub
, cmake, protobuf, protobufc
, libsodium, openssl
}:

stdenv.mkDerivation rec {
  pname   = "libnats";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner  = "nats-io";
    repo   = "nats.c";
    rev    = "v${version}";
    sha256 = "sha256-zqtPBxjTJ+/XxVpfVpyFIwvlj5xCcnTrUv2RGzP8UQc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libsodium openssl protobuf protobufc ];

  separateDebugInfo = true;
  outputs = [ "out" "dev" ];

  # https://github.com/nats-io/nats.c/issues/542
  postPatch = ''
    substituteInPlace src/libnats.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = with lib; {
    description = "C API for the NATS messaging system";
    homepage    = "https://github.com/nats-io/nats.c";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
