{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "b490d26340638934d13c0c0cd4089dec0fb6b85e";
  sha256 = "0cz76wcdlh5512g1aviv0ac9qwj1mmy9ncp6q4yywylxrlqgcbj5";
}
