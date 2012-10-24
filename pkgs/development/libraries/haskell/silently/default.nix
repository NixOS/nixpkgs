{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "silently";
  version = "1.2.4";
  sha256 = "0ac75b4n9566vpvv6jfcqafnyplv8dd7bgak89b16wy032z1xl5j";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/trystan/silently";
    description = "Prevent or capture writing to stdout and other handles";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
