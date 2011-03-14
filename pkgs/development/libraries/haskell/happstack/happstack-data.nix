{cabal, mtl, syb, sybWithClass, sybWithClassInstancesText, HaXml,
 happstackUtil, binary, text}:

cabal.mkDerivation (self : {
    pname = "happstack-data";
    version = "0.5.0.3";
    sha256 = "0zjsb9n1iawg2jv6i5q52awifly7yi6w0ilndivwp168qvi25awn";
    propagatedBuildInputs = [
        mtl syb sybWithClass sybWithClassInstancesText HaXml
        happstackUtil binary text
    ];
    meta = {
        description = "Happstack data manipulation libraries";
        license = "BSD";
        maintainers = [self.stdenv.lib.maintainers.andres];
    };
})
