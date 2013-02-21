{ cabal, classyPrelude, conduit, monadControl, resourcet
, transformers, void, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.5.1";
  sha256 = "1vwcxwrbnczchq2b773kjjr3ysc47widak8qj0kwi26nf3jics4k";
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
