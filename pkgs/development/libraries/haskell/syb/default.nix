{cabal}:

cabal.mkDerivation (self : {
  pname = "syb";
  version = "0.1.0.1";
  name = self.fname;
  sha256 = "08nf4id26s5iasxzdy5jds6h87fy3a55zgw0zrig4dg6difmwjp3";
  extraBuildInputs = [];
  meta = {
    description = "generics system described in the Scrap Your Boilerplate papers [..]";
  };
})
