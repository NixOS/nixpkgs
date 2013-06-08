{ cabal, cereal, libxmlSax, network, parsec, random, text
, transformers, vector, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "dbus";
  version = "0.10.4";
  sha256 = "0cv4sgk1mdxc81jlky21k0y3zg7qii585xiapr1m589r5528gj2f";
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
