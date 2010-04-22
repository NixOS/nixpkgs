{cabal, mtl, network, parsec, xhtml}:

cabal.mkDerivation (self : {
  pname = "cgi";
  version = "3001.1.7.2"; # Haskell Platform 2010.1.0.0
  sha256 = "ad35971388fa1809a5cd71bb2f051d69d753e4153b43d843b431674cf79a1c39";
  propagatedBuildInputs = [mtl network parsec xhtml];
  meta = {
    description = "A library for writing CGI programs";
  };
})  

