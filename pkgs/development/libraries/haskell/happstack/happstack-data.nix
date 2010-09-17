{cabal, mtl, sybWithClass, sybWithClassInstancesText, HaXml,
 happstackUtil, binary, text}:

cabal.mkDerivation (self : {
    pname = "happstack-data";
    version = "0.5.0.2";
    sha256 = "03795c24acc2268f39d38f18dd6cbfb92893f7de88b0443219d582a1eabdacd5";
    propagatedBuildInputs = [
        mtl sybWithClass sybWithClassInstancesText HaXml
        happstackUtil binary text
    ];
    meta = {
        description = "Happstack data manipulation libraries";
        license = "BSD";
        maintainers = [self.stdenv.lib.maintainers.andres];
    };
})
