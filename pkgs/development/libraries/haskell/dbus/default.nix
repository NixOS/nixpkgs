{ cabal, cereal, chell, chellQuickcheck, filepath, libxmlSax
, network, parsec, QuickCheck, random, text, transformers, vector
, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "dbus";
  version = "0.10.7";
  sha256 = "0xszynw6p07r7z9nlq8alx5lxfjm57gljya835ccj63hqhkr5yxh";
  buildDepends = [
    cereal libxmlSax network parsec random text transformers vector
    xmlTypes
  ];
  testDepends = [
    cereal chell chellQuickcheck filepath libxmlSax network parsec
    QuickCheck random text transformers vector xmlTypes
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://john-millikin.com/software/haskell-dbus/";
    description = "A client library for the D-Bus IPC system";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
