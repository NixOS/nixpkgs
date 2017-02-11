{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "a7e72af80fb1e68d9a2c4a5927a253b71ed68239";
  sha256 = "1ppk5r7yllvibsgxgs7k9kb2dcwh4pphf0876hcdh392cal47h3x";
}
