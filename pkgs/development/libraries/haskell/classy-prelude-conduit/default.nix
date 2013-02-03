{ cabal, classyPrelude, conduit, monadControl, resourcet
, transformers, void, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.4.4";
  sha256 = "1xsqdifqm68mlrmpmj04nqd5r83psq5ffis2pm8k8vwl1n1jv8kn";
  buildDepends = [
    classyPrelude conduit monadControl resourcet transformers void
    xmlConduit
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
