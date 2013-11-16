{ cabal, base16Bytestring, HUnit, text }:

cabal.mkDerivation (self: {
  pname = "direct-sqlite";
  version = "2.3.8";
  sha256 = "0qvqacjymrm6yy093p8biq3swdinh3lx75m27iz1p3ckdkw10lva";
  buildDepends = [ text ];
  testDepends = [ base16Bytestring HUnit text ];
  meta = {
    homepage = "http://ireneknapp.com/software/";
    description = "Low-level binding to SQLite3. Includes UTF8 and BLOB support.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
