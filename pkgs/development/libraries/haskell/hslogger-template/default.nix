{cabal, hslogger, mtl}:

cabal.mkDerivation (self : {
  pname = "hslogger-template";
  version = "1.0.0";
  sha256 = "0lnscbilzr5avi2h831kv2xhahh7pi5g054bw0sy57a1ccm2pvs1";
  propagatedBuildInputs = [ hslogger mtl ];
  meta = {
    description = "Library for generating hslogger functions using Template Haskell";
  };
})

