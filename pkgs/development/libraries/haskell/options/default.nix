{ cabal, chell, chellQuickcheck, monadsTf, transformers }:

cabal.mkDerivation (self: {
  pname = "options";
  version = "1.2";
  sha256 = "14qrkwd8h50wf6972p0ylvhnc8mh11fqk9l8q0h9lapj7ywm74vx";
  buildDepends = [ monadsTf transformers ];
  testDepends = [ chell chellQuickcheck monadsTf transformers ];
  doCheck = false;
  meta = {
    homepage = "https://john-millikin.com/software/haskell-options/";
    description = "A powerful and easy-to-use command-line option parser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
