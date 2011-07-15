{cabal, blazeBuilder, enumerator, network, httpTypes, text, transformers}:

cabal.mkDerivation (self : {
  pname = "wai";
  version = "0.4.0";
  sha256 = "1xp03g3q967rpgas896a5j3y7hjiir4ny0qlwmaj5ki61zivjsln";
  propagatedBuildInputs = [blazeBuilder enumerator network httpTypes text transformers];
  meta = {
    description = "Web Application Interface";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

