{cabal, mtl, sybWithClass, HaXml, happstackUtil, binary}:

cabal.mkDerivation (self : {
    pname = "happstack-data";
    version = "0.4.1";
    sha256 = "0d1f96472a4e13b9a5218bce8bf819a50d1773b7e110141ab235d1d7701e39f6";
    propagatedBuildInputs = [mtl sybWithClass HaXml happstackUtil binary];
    meta = {
        description = "Happstack data manipulation libraries";
        license = "BSD";
        maintainers = [self.stdenv.lib.maintainers.andres];
    };
})
