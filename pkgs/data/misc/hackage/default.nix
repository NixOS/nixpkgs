{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "901c2522e6797270f5ded4495b1a529e6c16ef45";
  sha256 = "0wng314y3yn6bbwa5ar254l7p8y99gsvm8ll4z7f3wg77v5fzish";
}
