{ cabal, blazeHtml, boolExtras, cmdargs, dataDefault, filepath
, HaXml, haxr, highlightingKate, hscolour, lens, mtl, pandoc
, pandocCiteproc, pandocTypes, parsec, split, strict, temporary
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "BlogLiterately";
  version = "0.7.1.7";
  sha256 = "05i0v5mrmnxbmrqrm473z6hs9j4c2jv1l81i4kdmm2wia6p93s90";
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
