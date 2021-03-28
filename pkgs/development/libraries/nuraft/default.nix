{ lib, stdenv, fetchFromGitHub, cmake, boost172, asio, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "nuraft";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eBay";
    repo = "NuRaft";
    rev = "v${version}";
    sha256 = "sha256-1k+AWmpAiHcQVEB5kUaMtNWhOnTBnmJiNU8zL1J/PEk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost172 asio openssl zlib ];

  meta = with lib; {
    homepage = "https://github.com/eBay/NuRaft";
    description = "C++ implementation of Raft core logic as a replication library";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wheelsandmetal ];
  };
}
