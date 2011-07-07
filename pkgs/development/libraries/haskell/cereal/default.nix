{cabal}:

cabal.mkDerivation (self : {
  pname = "cereal";
  version = "0.3.3.0";
  sha256 = "0bqd5qfvbz77mq0zxgafj011hrxcanrfzvlwhf4j4dzr6yryk53y";
  meta = {
    description = "A binary serialization library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
