{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "60443435510c1523ae4596f20595a274531dd485";
  sha256 = "1k3c0ix5rax92ywrpjxd7cmbzwsgrv03s6dvq6wjm8vljchqg4li";
}
