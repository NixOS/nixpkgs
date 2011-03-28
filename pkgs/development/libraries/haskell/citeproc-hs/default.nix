{cabal, json, mtl, pandocTypes, parsec, syb, utf8String, xml}:

cabal.mkDerivation (self : {
  pname = "citeproc-hs";
  version = "0.3.2";
  sha256 = "04lq0w1yjasn4i9siqpw41ia9f67xlv7vqwhs2a87hr1jnr09pgf";
  propagatedBuildInputs =
    [json mtl pandocTypes parsec syb utf8String xml];
  meta = {
    description = "A Citation Style Language implementation in Haskell";
  };
})

