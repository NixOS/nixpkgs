{cabal, mtl, time}:

cabal.mkDerivation (self : {
  pname = "convertible";
  version = "1.0.5";
  sha256 = "caf75727a35cf249690f3da60fce770642c8a1fad6080f3ba57e924fbe3c9465";
  propagatedBuildInputs = [mtl time];
  meta = {
    description = "Typeclasses and instances for converting between types";
  };
})  

