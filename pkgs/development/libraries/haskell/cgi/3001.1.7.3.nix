{cabal, mtl, network, parsec, xhtml}:

cabal.mkDerivation (self : {
  pname = "cgi";
  version = "3001.1.7.3"; # Haskell Platform 2010.2.0.0
  sha256 = "f1f4bc6b06e8a191db4ddb43617fee3ef37635e380d6a17c29efb5641ce91df0";
  propagatedBuildInputs = [mtl network parsec xhtml];
  meta = {
    description = "A library for writing CGI programs";
  };
})  

