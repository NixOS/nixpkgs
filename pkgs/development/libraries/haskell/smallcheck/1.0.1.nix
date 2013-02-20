{ cabal, dlist }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "0.6.2";
  sha256 = "0yz7an3k71ia7sgs8xpkh37xz9ipsnbf13680185cij8llq8zbyr";
  buildDepends = [ dlist ];
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "A property-based testing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
