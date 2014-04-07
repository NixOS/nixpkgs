{ cabal, cmdargs, Elm, filepath, mtl, snapCore, snapServer
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "elm-server";
  version = "0.11";
  sha256 = "1977fa03n2m2apxhbzpcn6b5y5gf7ksnpigibi8djlpp76rliaz2";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    cmdargs Elm filepath mtl snapCore snapServer unorderedContainers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://elm-lang.org";
    description = "Server for developing Elm projects";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
