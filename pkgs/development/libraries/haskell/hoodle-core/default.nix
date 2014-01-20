{ cabal, Diff, attoparsec, base64Bytestring, cairo, cereal, configurator, 
  coroutineObject, dbus, dyre, errors, fsnotify, gd, gtk, hoodleBuilder, 
  hoodleParser, hoodleRender, hoodleTypes, monadLoops, networkSimple,
  pureMD5, stm, xournalParser }:

cabal.mkDerivation (self: {
  pname = "hoodle-core";
  version = "0.13.0.0";
  sha256 = "1krq7i7kvymjhj9kar2rpy4qkbak8p4n1ifswdnk9r1dw7fr8vdx";
  buildDepends = [ Diff attoparsec base64Bytestring cairo cereal configurator 
                   coroutineObject dbus dyre errors fsnotify gd gtk hoodleBuilder
                   hoodleParser hoodleRender hoodleTypes monadLoops networkSimple
                   pureMD5 stm xournalParser ];
  #jailbreak = true;
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "Core library for hoodle";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim];
  };
})
