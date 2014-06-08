{ cabal, fetchurl, filemanip, Agda }:

cabal.mkDerivation (self: {
  pname = "Agda-stdlib";
  version = "0.7";

  src = fetchurl {
    url = "http://www.cse.chalmers.se/~nad/software/lib-0.7.tar.gz";
    sha256 = "1ynjgqk8hhnm6rbngy8fjsrd6i4phj2hlan9bk435bbywbl366k3";
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