{ cabal, blazeHtml, boolExtras, cmdargs, dataDefault, filepath
, HaXml, haxr, highlightingKate, hscolour, lens, mtl, pandoc
, pandocCiteproc, pandocTypes, parsec, split, strict, temporary
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "BlogLiterately";
  version = "0.7.1.6";
  sha256 = "0mzq0br9jsymml57kcxqyr401lckzm43fy74l3wy25n6grv64hd4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml boolExtras cmdargs dataDefault filepath HaXml haxr
    highlightingKate hscolour lens mtl pandoc pandocCiteproc
    pandocTypes parsec split strict temporary transformers utf8String
  ];
  meta = {
    homepage = "http://byorgey.wordpress.com/blogliterately/";
    description = "A tool for posting Haskelly articles to blogs";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
