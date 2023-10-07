{ pkgs, lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "gerbil-crypto";
  version = "unstable-2023-03-27";
  git-version = "0.0-18-ge57f887";
  gerbil-package = "clan/crypto";
  gerbilInputs = with gerbilPackages; [ gerbil-utils gerbil-poo ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.secp256k1 ];
  version-path = "version";
  softwareName = "Gerbil-crypto";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-crypto";
    rev = "e57f88742d9b41640b4a7d9bd3e86c688d4a83f9";
    sha256 = "08hrk3s82hbigvza75vgx9kc7qf64yhhn3xm5calc859sy6ai4ka";
  };

  meta = with lib; {
    description = "Gerbil Crypto: Extra Cryptographic Primitives for Gerbil";
    homepage    = "https://github.com/fare/gerbil-crypto";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
