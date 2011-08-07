{cabal, blazeBuilder, dataenc, text} :

cabal.mkDerivation (self : {
  pname = "mime-mail";
  version = "0.3.0.2";
  sha256 = "0jbhkghzj2wn1200917lr5vjx50maakakl3asfz6x1chprbqkdsx";
  propagatedBuildInputs = [ blazeBuilder dataenc text ];
  meta = {
    homepage = "http://github.com/snoyberg/mime-mail";
    description = "Compose MIME email messages.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
