{cabal, network, json, HTTP, mtl}:

cabal.mkDerivation (self : {
  pname = "CouchDB";
  version = "0.8.1.1";
  
  sha256 = "91edc35782e43a3b8dd5c5d3c303b88c05c57ba686e9565a11fe4d060f9372d7";

  propagatedBuildInputs = [network HTTP mtl json];
  meta = {
    description = "";
  };
})  

