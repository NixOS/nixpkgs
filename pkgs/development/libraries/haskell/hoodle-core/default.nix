{ cabal, attoparsec, base64Bytestring, binary, cairo, cereal
, configurator, coroutineObject, dbus, Diff, dyre, either, errors
, filepath, fsnotify, gd, gtk, hoodleBuilder, hoodleParser
, hoodleRender, hoodleTypes, lens, libX11, libXi, monadLoops, mtl
, network, networkInfo, networkSimple, pango, poppler, pureMD5, stm
, strict, svgcairo, systemFilepath, text, time, transformers
, transformersFree, uuid, xournalParser
}:

cabal.mkDerivation (self: {
  pname = "hoodle-core";
  version = "0.13.0.0";
  sha256 = "1krq7i7kvymjhj9kar2rpy4qkbak8p4n1ifswdnk9r1dw7fr8vdx";
  buildDepends = [
    attoparsec base64Bytestring binary cairo cereal configurator
    coroutineObject dbus Diff dyre either errors filepath fsnotify gd
    gtk hoodleBuilder hoodleParser hoodleRender hoodleTypes lens
    monadLoops mtl network networkInfo networkSimple pango poppler
    pureMD5 stm strict svgcairo systemFilepath text time transformers
    transformersFree uuid xournalParser
  ];
  extraLibraries = [ libX11 libXi ];
  jailbreak = true;
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "Core library for hoodle";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
