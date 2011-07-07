{cabal}:

cabal.mkDerivation (self : {
  pname = "clientsession";
  version = "0.6.0";
  sha256 = "0h92jjkhldn7f9b78cajfda8rprsj5scdsyl3pjpzicpvvy9g00y";
  meta = {
    description = "Store session data in a cookie";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

