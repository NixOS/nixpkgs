{cabal, HUnit, mtl, mtlparse}:

cabal.mkDerivation (self : {
  pname = "regexpr";
  version = "0.5.4";
  sha256 = "bf7813247f26877d9fba4ba4b66eb80bfddfc2086a5cd8d635b2da0ccde56604";
  propagatedBuildInputs = [HUnit mtl mtlparse];
  meta = {
    description = "regular expression library like Perl and Ruby's regular expressions";
  };
})
