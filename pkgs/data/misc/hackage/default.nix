{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "53fcf983669a3f0cdfd795fec28ecb40740a64ca";
  sha256 = "0jfrr6mjb3x1ybgrsinhm0nl3jmdjyf9mghpgsm75lgr83cm12a5";
}
