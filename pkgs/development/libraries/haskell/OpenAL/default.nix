{cabal, OpenGL, openal}:

cabal.mkDerivation (self : {
  pname = "OpenAL";
  version = "1.3.1.1"; # Haskell Platform 2009.0.0
  sha256 = "4875e015770feb93d5127d4b6f2338eb3957a0c36f64ccb8b3846010619f89b0";
  propagatedBuildInputs = [OpenGL openal];
  meta = {
    description = "A binding to the OpenAL cross-platform 3D audio API";
  };
})

