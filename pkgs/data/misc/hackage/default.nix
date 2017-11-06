{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "5e87c40f2cd96bd5dd953758e82f302107c7895e";
  sha256 = "12rw5fld64s0a2zjsdijfs0dv6vc6z7gcf24h4m2dmymzms4namg";
}
