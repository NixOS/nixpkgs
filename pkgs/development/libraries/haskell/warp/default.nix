{cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive,
 enumerator, httpTypes, network, simpleSendfile, transformers,
 unixCompat, wai} :

cabal.mkDerivation (self : {
  pname = "warp";
  version = "0.4.3";
  sha256 = "1g1fyys4j5cd2lp8818060i970f6fpxnjgyvb5m4r9asn7p1z4yc";
  propagatedBuildInputs = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive enumerator
    httpTypes network simpleSendfile transformers unixCompat wai
  ];
  meta = {
    homepage = "http://github.com/snoyberg/warp";
    description = "A fast, light-weight web server for WAI applications.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
