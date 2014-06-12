{ cabal, fetchurl, filemanip, Agda }:

cabal.mkDerivation (self: rec {
  pname = "Agda-stdlib";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/agda/agda-stdlib/archive/v${version}.tar.gz";
    sha256 = "1rz0jrkm1b8d8aj9hbj3yl2k219c57r0cizfx98qqf1b9mwixzbf";
  };

  buildDepends = [ filemanip Agda ];

  preConfigure = "cd ffi";

  postInstall = ''
      mkdir -p $out/share
      cd ..
      runhaskell GenerateEverything
      agda -i . -i src Everything.agda
      cp -pR src $out/share/agda
  '';

  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary";
    description = "A standard library for use with the Agda compiler.";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.jwiegley ];
  };
})