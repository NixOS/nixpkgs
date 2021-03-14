{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, curl, zeromq, czmq, libsodium }:

stdenv.mkDerivation rec {
  pname = "prime-server";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "kevinkreiser";
    repo = "prime_server";
    rev = version;
    sha256 = "027w3cqfnciyy2x78hfclpb77askn773fab37mzwf6r3mcc7vyl5";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ curl zeromq czmq libsodium ];

  meta = with lib; {
    description = "Non-blocking (web)server API for distributed computing and SOA based on zeromq";
    homepage = "https://github.com/kevinkreiser/prime_server";
    license = licenses.bsd2;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
