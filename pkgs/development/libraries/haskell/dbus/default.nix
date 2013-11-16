{ cabal, cereal, libxmlSax, network, parsec, random, text
, transformers, vector, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "dbus";
  version = "0.10.5";
  sha256 = "1wblqkwlwv3bxhz2n4qm0w0npawng86y2hyacjxmx8cw25gkw41x";
  buildDepends = [
    cereal libxmlSax network parsec random text transformers vector
    xmlTypes
  ];
  jailbreak = true;
  meta = {
    homepage = "https://john-millikin.com/software/haskell-dbus/";
    description = "A client library for the D-Bus IPC system";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
