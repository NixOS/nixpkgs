{cabal, binary, blazeHtml, hamlet, mtl, network, pandoc, regexBase,
 regexTDFA}:

cabal.mkDerivation (self : {
  pname = "hakyll";
  version = "2.4.3";
  sha256 = "1n1hibwhg22l9p126d10zwhvaab46svcri2rkvd78f4vhmwpvkbs";
  propagatedBuildInputs =
    [binary blazeHtml hamlet mtl network pandoc regexBase regexTDFA];
  meta = {
    description = "A simple static site generator library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
