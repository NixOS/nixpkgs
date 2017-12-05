{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "43b26c8a8f64f6caf7b4345eff0099798adcac28";
  sha256 = "1yfaxzgdrf7cifz4qq462amja2iq7r99nvpggggs8scwg4dz1i0b";
}
