{cabal}:

cabal.mkDerivation (self : {
  pname = "syb";
  version = "0.3.3"; # for ghc-7.2.1
  sha256 = "0jskxbnzariq2ahcymvjrp4bhl9cpflc1nh51whdl9axcrd5c901";
  meta = {
    description = "generics system described in the Scrap Your Boilerplate papers";
  };
})
