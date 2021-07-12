{ pkgs, lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "gerbil-crypto";
  version = "unstable-2021-02-24";
  git-version = "0.0-15-gef0ef55";
  gerbil-package = "clan/crypto";
  gerbilInputs = with gerbilPackages; [ gerbil-utils gerbil-poo ];
  version-path = "version";
  softwareName = "Gerbil-crypto";

  buildInputs = with pkgs; [ secp256k1 pkg-config ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-crypto";
    rev = "ef0ef55de1de8000a292040124fcb1e5b7ef0dda";
    sha256 = "1i4sc3xbkqj90419x7gylv7is73cafk5gqh6ldxfa2d29k4z9ma4";
  };

  meta = with lib; {
    description = "Gerbil Crypto: Extra Cryptographic Primitives for Gerbil";
    homepage    = "https://github.com/fare/gerbil-crypto";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
