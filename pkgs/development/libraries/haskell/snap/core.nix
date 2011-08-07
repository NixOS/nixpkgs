{cabal, MonadCatchIOTransformers, attoparsec, attoparsecEnumerator,
 blazeBuilder, bytestringMmap, bytestringNums, caseInsensitive,
 deepseq, dlist, enumerator, mtl, text, transformers, unixCompat,
 vector, zlib} :

cabal.mkDerivation (self : {
  pname = "snap-core";
  version = "0.5.2";
  sha256 = "1wjjgghq21mw4sw6xyfsf2hazk78wgnphhaw3qz9jpkff2s39lhl";
  propagatedBuildInputs = [
    MonadCatchIOTransformers attoparsec attoparsecEnumerator
    blazeBuilder bytestringMmap bytestringNums caseInsensitive deepseq
    dlist enumerator mtl text transformers unixCompat vector zlib
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework (Core)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
