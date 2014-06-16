{ cabal, fetchurl, filemanip, Agda }:

cabal.mkDerivation (self: {
  pname = "Agda-lib-ffi";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/agda/agda-stdlib/archive/v2.4.0.tar.gz";
    sha256 = "1rz0jrkm1b8d8aj9hbj3yl2k219c57r0cizfx98qqf1b9mwixzbf";
  };

  buildDepends = [ filemanip Agda ];
  jailbreak = true;             # otherwise, it complains about base

  preConfigure = "cd ffi";

  postInstall = ''
      mkdir -p $out/share
      cd ..
      runhaskell GenerateEverything
      ${Agda}/bin/agda -i . -i src Everything.agda
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