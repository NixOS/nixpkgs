{cabal, HaXml, HTTP, dataenc, time}:

cabal.mkDerivation (self : {
  pname = "haxr";
  version = "3000.1.1.2";
  sha256 = "c24741a92e27d851a3376158230a52782c1e2b494405ebdde1d256819598c8e8";
  meta = {
    description = "a Haskell library for writing XML-RPC client and server applications";
  };
  propagatedBuildInputs = [HaXml HTTP dataenc time];
})

