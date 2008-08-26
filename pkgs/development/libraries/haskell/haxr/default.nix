{cabal, HaXml, HTTP}:

cabal.mkDerivation (self : {
  pname = "haxr";
  version = "3000.0.1";
  sha256 = "1sppfd8qyqggfh5m8phxdn40x17g97q6j3a8d5wspy7kcmg2qaci";
  meta = {
    description = "a Haskell library for writing XML-RPC client and server applications";
  };
  propagatedBuildInputs = [HaXml HTTP];
})

