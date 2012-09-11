{ cabal, mtl, network, split }:

cabal.mkDerivation (self: {
  pname = "urlencoded";
  version = "0.3.0.1";
  sha256 = "1i6r05d5libcilngsa6illcazfv6g4rhibzgk8c2jsjq9cg53ihz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl network split ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/pheaver/urlencoded";
    description = "Generate or process x-www-urlencoded data";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
