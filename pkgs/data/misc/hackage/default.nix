{ fetchFromGitHub }:

# Use builtins.fetchTarball "https://github.com/commercialhaskell/all-cabal-hashes/archive/hackage.tar.gz"
# instead if you want the latest Hackage automatically at the price of frequent re-downloads.

fetchFromGitHub {
  owner = "commercialhaskell";
  repo = "all-cabal-hashes";
  rev = "43b26c8a8f64f6caf7b4345eff0099798adcac28";
  sha256 = "0p5w7x690aqmywxgpigmsig83lnbpx37332gpcn1licxb6wya0dm";
}
