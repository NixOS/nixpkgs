{ cabal, blazeBuilder, blazeHtml, failure, parsec, shakespeare
, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "0.10.0";
  sha256 = "0xqlc03g0qnpnrw957108rpjbs88p9wwvcgmz7vc1f0k88lc0h6n";
  buildDepends = [
    blazeBuilder blazeHtml failure parsec shakespeare text
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "Haml-like template files that are compile-time checked";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
