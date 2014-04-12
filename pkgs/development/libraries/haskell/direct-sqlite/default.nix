{ cabal, base16Bytestring, HUnit, text }:

cabal.mkDerivation (self: {
  pname = "direct-sqlite";
  version = "2.3.12";
  sha256 = "14dcgmn3mfx69qx412dc8cxa4ia3adsf8gm5q4yscpp8rf78m178";
  buildDepends = [ text ];
  testDepends = [ base16Bytestring HUnit text ];
  meta = {
    homepage = "http://ireneknapp.com/software/";
    description = "Low-level binding to SQLite3. Includes UTF8 and BLOB support.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
