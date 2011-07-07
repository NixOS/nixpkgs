{cabal, parsec, ranges}:

cabal.mkDerivation (self : {
  pname = "email-validate";
  version = "0.2.6";
  sha256 = "1nw4r5wyck30r6n0bjxwybpkw2dqr2mp4y8fy6ypra9zhhw1jd8m";
  propagatedBuildInputs = [parsec ranges];
  meta = {
    description = "Validating an email address string against RFC 5322";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

