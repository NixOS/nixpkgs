{cabal, binary, blazeHtml, hamlet, hopenssl, mtl, network, pandoc, regexBase
, regexPCRE, snapCore, snapServer, strictConcurrency}:

cabal.mkDerivation (self : {
  pname = "hakyll";
  version = "3.0.2.0";
  sha256 = "0d1kmvkbwygr9mxz7m8jiasrbj470j4hwsj8mmkdgdm9clxbi74k";
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
