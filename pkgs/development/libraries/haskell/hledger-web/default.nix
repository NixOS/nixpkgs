{ cabal, aeson, cmdargs, failure, fileEmbed, hamlet, hledger
, hledgerLib, HUnit, ioStorage, parsec, regexpr, safe, text, time
, transformers, wai, waiExtra, warp, yesodCore, yesodForm
, yesodJson, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.15.3";
  sha256 = "1z2pimxz2ykfb89qwp6cil4nljn8pcz8n7pjhvk948zsd96n2i6f";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson cmdargs failure fileEmbed hamlet hledger hledgerLib HUnit
    ioStorage parsec regexpr safe text time transformers wai waiExtra
    warp yesodCore yesodForm yesodJson yesodStatic
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
