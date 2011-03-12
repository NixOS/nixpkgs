{cabal, parsec}:

cabal.mkDerivation (self : {
  pname = "network";
  version = "2.3.0.2"; # Haskell Platform 2011.2.0.0
  sha256 = "1s4hm0ilsd67ircrl0h5b72kwrw1imb3cj5z52h99bv7qjdbag03";
  propagatedBuildInputs = [parsec];
  meta = {
    description = "Networking-related facilities";
  };
})  

