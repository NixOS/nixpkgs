{ cabal, deepseq, nanospec }:

cabal.mkDerivation (self: {
  pname = "silently";
  version = "1.2.4.1";
  sha256 = "035dw3zg680ykyz5rqkkrjn51wkznbc4jb45a8l2gh3vgqzgbf52";
  buildDepends = [ deepseq ];
  testDepends = [ deepseq nanospec ];
  meta = {
    homepage = "https://github.com/trystan/silently";
    description = "Prevent or capture writing to stdout and other handles";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
