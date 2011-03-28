{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "Shellac";
  version = "0.9.5";
  sha256 = "a8b07918be23b7e7c3114aed7d929f95ace37fbacd82f185358f05f337f09c70";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "A framework for creating shell environments";
  };
})

