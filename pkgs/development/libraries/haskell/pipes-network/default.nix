{ cabal, network, networkSimple, pipes, pipesSafe, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-network";
  version = "0.6.3";
  sha256 = "09gihca0hinq3sqsx9753gmas6g22pg792ag6ckdw5z3607razrg";
  buildDepends = [
    network networkSimple pipes pipesSafe transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/k0001/pipes-network";
    description = "Use network sockets together with the pipes library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
