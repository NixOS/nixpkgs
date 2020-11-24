{ pkgs, lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "gerbil-crypto";
  version = "unstable-2021-05-10";
  git-version = "0.0-16-g4c7c4a8";
  gerbil-package = "clan/crypto";
  gerbilInputs = with gerbilPackages; [ gerbil-utils gerbil-poo ];
  version-path = "version";
  softwareName = "Gerbil-crypto";

  buildInputs = with pkgs; [ secp256k1 pkg-config ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-crypto";
    rev = "4c7c4a852b1a13af91ba2b7435218cd9dd8b8b6e";
    sha256 = "1k4bidi4anqwg0l58qzyqzgcwynhbas2s592fm7pga4akisbqzlz";
  };

  meta = with lib; {
    description = "Gerbil Crypto: Extra Cryptographic Primitives for Gerbil";
    homepage    = "https://github.com/fare/gerbil-crypto";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
