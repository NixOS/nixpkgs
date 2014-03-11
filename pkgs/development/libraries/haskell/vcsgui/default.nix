{ cabal, filepath, gtk3, MissingH, mtl, vcswrapper }:

cabal.mkDerivation (self: {
  pname = "vcsgui";
  version = "0.0.2";
  sha256 = "0kj06l9s4l791ffwdnh7j0nvjvgili18g2jl2ik81n28bzfyq1dx";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath gtk3 MissingH mtl vcswrapper ];
  meta = {
    homepage = "https://github.com/forste/haskellVCSGUI";
    description = "GUI library for source code management systems";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
