{ cabal, cereal, libxmlSax, network, parsec, random, text
, transformers, vector, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "dbus";
  version = "0.10.6";
  sha256 = "0jbysa7czhp7yl3fb6sxiqppg8yb3cdk4v8hcs4y8yzwjj0lm7mf";
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
