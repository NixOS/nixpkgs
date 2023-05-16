<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, cmake, boost, asio, openssl, zlib }:
=======
{ lib, stdenv, fetchFromGitHub, cmake, boost172, asio, openssl, zlib }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
  buildInputs = [ boost asio openssl zlib ];
=======
  buildInputs = [ boost172 asio openssl zlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/eBay/NuRaft";
    description = "C++ implementation of Raft core logic as a replication library";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ wheelsandmetal ];
    platforms = platforms.all;
=======
    platforms = platforms.linux;
    maintainers = with maintainers; [ wheelsandmetal ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
