{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "stateref";
  version = "0.3";
  sha256 = "0hdpw6g255lj7jjvgqwhjdpzmka546vda5qjvry8gjj6nfm91lvx";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Abstraction for things that work like IORef";
    license = "Public Domain";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

