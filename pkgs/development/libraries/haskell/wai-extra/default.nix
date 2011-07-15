{cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive, enumerator,
 httpTypes, network, text, transformers, wai, zlibBindings}:

cabal.mkDerivation (self : {
  pname = "wai-extra";
  version = "0.4.0.1";
  sha256 = "0xj7dkwqa9axgm6cizf2kd97fakbmq5580mian888i5f21jn1n2z";
  propagatedBuildInputs = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive enumerator
    httpTypes network text transformers wai zlibBindings
  ];
  meta = {
    description = "Provides some basic WAI handlers and middleware";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

