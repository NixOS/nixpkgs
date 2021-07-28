{ lib
, stdenv
, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation rec {
  pname = "rpclib";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "rpclib";
    repo = "rpclib";
    rev = "v${version}";
    sha256 = "0dlbkl47zd2fkxwbn93w51wmvfr8ssp4zribn5wi4cpiky44a4g9";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "RPC library for C++, providing both a client and server implementation";
    homepage = "https://github.com/rpclib/rpclib/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ balodja ];
  };
}
