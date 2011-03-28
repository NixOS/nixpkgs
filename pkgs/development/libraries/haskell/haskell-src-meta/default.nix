{cabal, haskellSrcExts}:

cabal.mkDerivation (self : {
  pname = "haskell-src-meta";
  version = "0.0.5";
  sha256 = "96e55d6b5237043f8b3943b40c55e26ef6a2806d1314d784202135497e645add";
  propagatedBuildInputs = [haskellSrcExts];
  meta = {
    description = "Parse source to template-haskell abstract syntax";
  };
})

