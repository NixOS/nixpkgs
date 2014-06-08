{ cabal, deepseq, filepath, mtl, optparseApplicative, tagged, tasty
, temporaryRc
}:

cabal.mkDerivation (self: {
  pname = "tasty-golden";
  version = "2.2.1.1";
  sha256 = "0a265l7fwc0sxzdy9b0jf8f5w4nws6pwhhaw1pa7qx3c8fm9v54i";
  buildDepends = [
    deepseq filepath mtl optparseApplicative tagged tasty temporaryRc
  ];
  meta = {
    homepage = "https://github.com/feuerbach/tasty-golden";
    description = "Golden tests support for tasty";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
