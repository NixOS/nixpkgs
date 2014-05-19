{ cabal, dataDefault, exceptions, transformers }:

cabal.mkDerivation (self: {
  pname = "retry";
  version = "0.4";
  sha256 = "16njq924b5n7jyfc059dbypp529gqlc9qnzd7wjk4m7dpm5bww67";
  buildDepends = [ dataDefault exceptions transformers ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/Soostone/retry";
    description = "Retry combinators for monadic actions that may fail";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
