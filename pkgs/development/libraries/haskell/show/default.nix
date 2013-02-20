{ cabal, QuickCheck, random, smallcheck, syb }:

cabal.mkDerivation (self: {
  pname = "show";
  version = "0.4.1.2";
  sha256 = "1qaphxjaxng7d0kcn3vvxbvqljzzs1hvmsrdsm3pbi19qlsavd5w";
  buildDepends = [ QuickCheck random smallcheck syb ];
  patchPhase = ''
    sed -i -e 's|smallcheck>=0.4|smallcheck >=0.4 \&\& <= 1|' show.cabal
  '';
  meta = {
    description = "'Show' instances for Lambdabot";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
