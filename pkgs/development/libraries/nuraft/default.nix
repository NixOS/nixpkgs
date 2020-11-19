{ stdenv, fetchFromGitHub, cmake, boost172, asio, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "nuraft";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "eBay";
    repo = "NuRaft";
    rev = "v${version}";
    sha256 = "sha256-l6rG8f+JAWfAJxEZPKRHZo2k8x9WbtSJC3gGCSMHYfs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost172 asio openssl zlib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/eBay/NuRaft";
    description = "C++ implementation of Raft core logic as a replication library";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wheelsandmetal ];
  };
}
