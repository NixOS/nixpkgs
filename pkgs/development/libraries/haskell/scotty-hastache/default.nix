{ cabal, blazeHtml, blazeMarkup, filepath, hastache, httpTypes, mtl
, scotty, text, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty-hastache";
  version = "0.2.0";
  sha256 = "105cxlasj4sl4ddzg8ms6k95078q10zcm2c86jcn76s0jmv95669";
  buildDepends = [
    blazeHtml blazeMarkup filepath hastache httpTypes mtl scotty text
    wai warp
  ];
  meta = {
    homepage = "https://github.com/scotty-web/scotty-hastache";
    description = "Easy Mustache templating support for Scotty";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
