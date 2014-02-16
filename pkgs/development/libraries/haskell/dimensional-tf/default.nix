{ cabal, numtypeTf, time }:

cabal.mkDerivation (self: {
  pname = "dimensional-tf";
  version = "0.3";
  sha256 = "0z3k9962zz652bk2azv9lcms1j06v60hid3iach043dpg5r083qg";
  buildDepends = [ numtypeTf time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions, implemented using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
