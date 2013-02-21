{ cabal, classyPrelude, conduit, monadControl, resourcet
, transformers, void, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.5.0";
  sha256 = "1c1j9cxj08nz1pkrdxhphk6zyn1dxf3wbl8phcrzi8qk6q1vi0bi";
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
