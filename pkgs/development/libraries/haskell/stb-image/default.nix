{cabal, bitmap}:

cabal.mkDerivation (self : {
  pname = "stb-image";
  version = "0.2";
  sha256 = "7d027b6de52d07bbe439a84897aaa6e26a8f05c6fa6f4aeaa3060be23ae11937";
  propagatedBuildInputs = [bitmap];
  meta = {
    description = "A wrapper around Sean Barrett's JPEG/PNG decoder";
    license = "free";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

