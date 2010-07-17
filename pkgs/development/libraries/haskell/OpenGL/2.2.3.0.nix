{cabal, mesa, libX11}:

cabal.mkDerivation (self : {
  pname = "OpenGL";
  version = "2.2.3.0"; # Haskell Platform 2010.1.0.0 and 2010.2.0.0
  sha256 = "a75c3277bb20fda9a4ac1eb0e838fe4b5baf92f5539466b92bd255626afb0502";
  propagatedBuildInputs = [mesa libX11];
  meta = {
    description = "A binding for the OpenGL graphics system";
  };
})  

