{ cabal, cereal, libxmlSax, network, parsec, random, text
, transformers, vector, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "dbus";
  version = "0.10.3";
  sha256 = "1l74whkrznlycl6rc1h63rc1vmvp6q2g8g92imycf8f4sizmigfq";
  buildDepends = [
    cereal libxmlSax network parsec random text transformers vector
    xmlTypes
  ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-dbus/";
    description = "A client library for the D-Bus IPC system";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
