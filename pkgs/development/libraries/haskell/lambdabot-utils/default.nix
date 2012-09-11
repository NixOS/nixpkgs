{ cabal, binary, haskellSrc, mtl, network, random, regexCompat
, regexPosix, syb, tagsoup, utf8String, zlib
}:

cabal.mkDerivation (self: {
  pname = "lambdabot-utils";
  version = "4.2.1";
  sha256 = "1a5rj8zjvfhziwldikgki92lg9bwv6h9ysp6yqip6lja18h4lilx";
  buildDepends = [
    binary haskellSrc mtl network random regexCompat regexPosix syb
    tagsoup utf8String zlib
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Lambdabot";
    description = "Utility libraries for the advanced IRC bot, Lambdabot";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
