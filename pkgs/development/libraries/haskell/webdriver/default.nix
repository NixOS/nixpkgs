{ cabal, aeson, attoparsec, base64Bytestring, cond, dataDefault
, directoryTree, exceptions, filepath, HTTP, liftedBase
, monadControl, mtl, network, parallel, scientific, temporary, text
, time, transformers, transformersBase, unorderedContainers, vector
, zipArchive
}:

cabal.mkDerivation (self: {
  pname = "webdriver";
  version = "0.5.5";
  sha256 = "1k656ghkaqlnp4a9dd99s3l2vm21zsqpqxwfg2lq5rx2yw402nga";
  buildDepends = [
    aeson attoparsec base64Bytestring cond dataDefault directoryTree
    exceptions filepath HTTP liftedBase monadControl mtl network
    scientific temporary text time transformers transformersBase
    unorderedContainers vector zipArchive
  ];
  testDepends = [ parallel text ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/kallisti-dev/hs-webdriver";
    description = "a Haskell client for the Selenium WebDriver protocol";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
