{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.1.0";
  sha256 = "063mssiq57g4bsalp653fa4yj9wmaynvg0x7vk67gds2l2zpd2gy";
  patchPhase = ''
    sed -i Setup.hs -e 's|main = defaultMain|main = defaultMainWithHooks autoconfUserHooks|'
  '';
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
