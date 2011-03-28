{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "fgl";
  version = "5.4.2.3"; # Haskell Platform 2010.2.0.0 and 2011.2.0.0
  sha256 = "1f46siqqv8bc9v8nxr72nxabpzfax117ncgdvif6rax5ansl48g7";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Martin Erwig's Functional Graph Library";
  };
})

