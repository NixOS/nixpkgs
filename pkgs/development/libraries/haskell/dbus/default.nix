{ cabal, cereal, libxmlSax, network, parsec, random, text
, transformers, vector, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "dbus";
  version = "0.10.1";
  sha256 = "180923lp09pwcvxffxyq753mq7zp7dyxgaj3h13wfsrhfia0awz8";
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
