{cabal, mesa, libX11}:

cabal.mkDerivation (self : {
  pname = "OpenGL";
  version = "2.2.3.0"; # Haskell Platform 2010.1.0.0, 2010.2.0.0, 2011.2.0.0
  sha256 = "00h5zdm64mfj5fwnd52kyn9aynsbzqwfic0ymjjakz90pdvk4p57";
  propagatedBuildInputs = [mesa libX11];
  meta = {
    description = "A binding for the OpenGL graphics system";
  };
})  

