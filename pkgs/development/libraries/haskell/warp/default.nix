{cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive, enumerator,
 httpTypes, network, simpleSendfile, transformers, unixCompat, wai}:

cabal.mkDerivation (self : {
  pname = "warp";
  version = "0.4.1.1";
  sha256 = "0qck4mpg4p6v2yx2r6qchqd3lvsn8n5ys6xsm11hhznc2r50aayh";
  propagatedBuildInputs = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive enumerator
    httpTypes network simpleSendfile transformers unixCompat wai
  ];
  meta = {
    description = "A fast, light-weight web server for WAI applications";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

