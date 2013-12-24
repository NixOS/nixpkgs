{ cabal, base16Bytestring, HUnit, text }:

cabal.mkDerivation (self: {
  pname = "direct-sqlite";
  version = "2.3.9";
  sha256 = "0haq14acdijd41jvah6f6l6qlqc4wjp3mwkx57pz4q5m6qvxrz44";
  buildDepends = [ text ];
  testDepends = [ base16Bytestring HUnit text ];
  meta = {
    homepage = "http://ireneknapp.com/software/";
    description = "Low-level binding to SQLite3. Includes UTF8 and BLOB support.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
