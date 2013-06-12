{ cabal, Cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "atomic-primops";
  version = "0.1.0.2";
  sha256 = "1qjm97hi2wr658yk7f5cfppizaawmrkvs2q7qzq00h14fr71xxca";
  buildDepends = [ Cabal primitive ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "A safe approach to CAS and other atomic ops in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
