{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "ee101d34ff8bd59897aa2eb0a124bcd3fb47ceec";
  sha256 = "1hky0s2c1rv1srfnhbyi3ny14rnfnnp2j9fsr4ylz76xyxgjf5wm";
}
