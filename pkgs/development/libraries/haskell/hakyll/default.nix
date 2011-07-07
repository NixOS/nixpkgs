{cabal, binary, blazeHtml, hamlet, hopenssl, mtl, network, pandoc, regexBase
, regexPCRE, snapCore, snapServer, strictConcurrency}:

cabal.mkDerivation (self : {
  pname = "hakyll";
  version = "3.2.0.3";
  sha256 = "0biy9p662anhhlmwa502iy8cck597q0vlwj57l6cj8kpyxj4g0lz";
  propagatedBuildInputs =
    [ binary blazeHtml hamlet hopenssl mtl network pandoc regexBase
     regexPCRE snapCore snapServer strictConcurrency
    ];
  meta = {
    description = "A simple static site generator library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
