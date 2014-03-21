{ cabal, alsaCore, alsaLib, c2hs }:

cabal.mkDerivation (self: {
  pname = "alsa-mixer";
  version = "0.2.0.1";
  sha256 = "1306kw4w85d3pkdqjw8cwx77a2mbhw2hlmxcjczym1nsyp4rhyhr";
  buildDepends = [ alsaCore ];
  buildTools = [ c2hs ];
  extraLibraries = [ alsaLib ];
  meta = {
    homepage = "https://github.com/ttuegel/alsa-mixer";
    description = "Bindings to the ALSA simple mixer API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.linux;
  };
})
