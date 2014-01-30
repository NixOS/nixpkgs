{ cabal, base16Bytestring, HUnit, text }:

cabal.mkDerivation (self: {
  pname = "direct-sqlite";
  version = "2.3.11";
  sha256 = "0pd5qv8aq47d5n2sd99yblxiq70zvmy2rc71ys73a3d846k0ncs0";
  buildDepends = [ text ];
  testDepends = [ base16Bytestring HUnit text ];
  meta = {
    homepage = "http://ireneknapp.com/software/";
    description = "Low-level binding to SQLite3. Includes UTF8 and BLOB support.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
