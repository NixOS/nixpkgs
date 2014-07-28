{ cabal, hasteCompiler, mtl }:

cabal.mkDerivation (self: {
  pname = "haste-perch";
  version = "0.1.0.0";
  sha256 = "0g2ijb0mzqs2iq4i47biaxbsg4v15w9ky6yyz6wmngwf06rg4iwj";
  buildDepends = [ hasteCompiler mtl ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/agocorona/haste-perch";
    description = "Create dynamic HTML in the browser using blaze-html-style notation with Haste";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
