{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "5c5b04af472eb6c2854b21cb52ee6324252280de";
  sha256 = "1cnr350044yrlg7wa09fmdarl7y9gkydh25lv94wcqg3w9cdv0fb";
}
