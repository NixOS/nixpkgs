{ cabal, bindingsDSL, HUnit, libX11, libXext, libXfixes, libXi
, libXrandr, libXxf86vm, mesa, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "bindings-GLFW";
  version = "3.0.3.2";
  sha256 = "1w4y2ha5x678fiyan79jd59mjrkf4q25v8049sj20fbmabgdqla9";
  buildDepends = [ bindingsDSL ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  extraLibraries = [
    libX11 libXext libXfixes libXi libXrandr libXxf86vm mesa
  ];
  doCheck = false;
  meta = {
    description = "Low-level bindings to GLFW OpenGL library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
