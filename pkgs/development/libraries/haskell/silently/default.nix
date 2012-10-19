{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "silently";
  version = "1.2.3";
  sha256 = "1fvkj5qngdi2zxsrfk6dnaynm0wbxpmqr0jzvzayxifhzh04mqld";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/trystan/silently";
    description = "Prevent or capture writing to stdout and other handles";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
