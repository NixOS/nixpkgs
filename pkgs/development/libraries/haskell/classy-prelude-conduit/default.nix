{ cabal, classyPrelude, conduit, monadControl, resourcet
, transformers, void, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.4.3";
  sha256 = "0ny4si6z6i6g6khcg9d3m9wks42sqh8i8kpgghhdwd37v32l3f34";
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
