{ lib, stdenv, fetchFromGitHub, cmake, boost, asio, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "nuraft";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "eBay";
    repo = "NuRaft";
    rev = "v${version}";
    sha256 = "sha256-puO8E7tSLqB0oq/NlzEZqQgIZKm7ZUb4HhR0XuI9dco=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost asio openssl zlib ];

  meta = with lib; {
    homepage = "https://github.com/eBay/NuRaft";
    description = "C++ implementation of Raft core logic as a replication library";
    license = licenses.asl20;
    maintainers = with maintainers; [ wheelsandmetal ];
    platforms = platforms.all;
  };
}
