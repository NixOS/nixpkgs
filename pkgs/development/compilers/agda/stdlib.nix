{ cabal, fetchurl, filemanip, Agda }:

cabal.mkDerivation (self: rec {
  pname = "Agda-stdlib";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/agda/agda-stdlib/archive/v${version}.tar.gz";
    sha256 = "03gdcy2gar46qlmd6w91y05cm1x304ig6bda90ryww9qn05kif78";
  };

  buildDepends = [ filemanip Agda ];

  preConfigure = "cd ffi";

  postInstall = ''
      mkdir -p $out/share
      cd ..
      ${self.ghc.ghc}/bin/runhaskell GenerateEverything
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