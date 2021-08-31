{ lib, stdenv, fetchFromGitHub, cmake, boost172, asio, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "nuraft";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "eBay";
    repo = "NuRaft";
    rev = "v${version}";
    sha256 = "sha256-Fyy9B5CXyMcDSOdqaeJ4ejo1svM90ESXuNL0rzsTZpE=";
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
