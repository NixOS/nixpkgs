{ pkgs, lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "gerbil-crypto";
  version = "unstable-2023-11-29";
  git-version = "0.1-1-g4197bfa";
  gerbil-package = "clan/crypto";
  gerbilInputs = with gerbilPackages; [ gerbil-utils gerbil-poo ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.secp256k1 ];
  version-path = "version";
  softwareName = "Gerbil-crypto";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-crypto";
    rev = "4197bfa71dc55657f79efd5cc21fe59839e840f2";
    sha256 = "1jdfz5x24dfvpwyfxalkhv83gf9ylyaqii1kg8rjl8dzickawrix";
  };

  meta = with lib; {
    description = "Gerbil Crypto: Extra Cryptographic Primitives for Gerbil";
    homepage    = "https://github.com/fare/gerbil-crypto";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
