{ cabal }:

cabal.mkDerivation (self: {
  pname = "TraceUtils";
  version = "0.1.0.2";
  sha256 = "0la19yynd7bpswi9012hf0vl9c4fdnn8p6y0287xanmdcs9zqz16";
  meta = {
    homepage = "https://github.com/Peaker/TraceUtils";
    description = "Functions that should have been in Debug.Trace";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
