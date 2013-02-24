{ cabal, QuickCheck, testFramework, testFrameworkQuickcheck2
, zeromq
}:

cabal.mkDerivation (self: {
  pname = "zeromq3-haskell";
  version = "0.2";
  sha256 = "12qljfkcd4l9h3l80jibxgw2an6v782w0sxwvzxqmma29jv6hvky";
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2
  ];
  extraLibraries = [ zeromq ];
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "Bindings to ZeroMQ 3.x";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
