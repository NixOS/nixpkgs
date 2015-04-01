{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_35;

  # Disable GHC 7.10.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # Cabal_1_22_1_1 requires filepath >=1 && <1.4
  cabal-install = dontCheck (super.cabal-install.override { Cabal = null; });

  # We have Cabal 1.22.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = null; };

  # GHC 7.10.x's Haddock binary cannot generate hoogle files.
  # https://ghc.haskell.org/trac/ghc/ticket/9921
  mkDerivation = drv: super.mkDerivation (drv // { doHoogle = false; });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;
  bytestring-builder = dontHaddock super.bytestring-builder;

  # These used to be core packages in GHC 7.8.x.
  old-locale = self.old-locale_1_0_0_7;
  old-time = self.old-time_1_1_0_3;

  # We have transformers 4.x
  mtl = self.mtl_2_2_1;
  transformers-compat = disableCabalFlag super.transformers-compat "three";

  # We have time 1.5
  aeson = disableCabalFlag super.aeson "old-locale";

  # requires filepath >=1.1 && <1.4
  Glob = doJailbreak super.Glob;

  # Setup: At least the following dependencies are missing: base <4.8
  hspec-expectations = overrideCabal super.hspec-expectations (drv: {
    patchPhase = "sed -i -e 's|base < 4.8|base|' hspec-expectations.cabal";
  });
  utf8-string = overrideCabal super.utf8-string (drv: {
    patchPhase = "sed -i -e 's|base >= 3 && < 4.8|base|' utf8-string.cabal";
  });
  esqueleto = doJailbreak super.esqueleto;

  # bos/attoparsec#92
  attoparsec = dontCheck super.attoparsec;

  # Test suite fails with some (seemingly harmless) error.
  # https://code.google.com/p/scrapyourboilerplate/issues/detail?id=24
  syb = dontCheck super.syb;

  # Test suite has stricter version bounds
  retry = dontCheck super.retry;

  # Test suite fails with time >= 1.5
  http-date = dontCheck super.http-date;

  # Version 1.19.5 fails its test suite.
  happy = dontCheck super.happy;

  # Test suite fails in "/tokens_bytestring_unicode.g.bin".
  alex = dontCheck super.alex;

  # TODO: should eventually update the versions in hackage-packages.nix
  haddock-library = overrideCabal super.haddock-library (drv: {
    version = "1.2.0";
    sha256 = "0kf8qihkxv86phaznb3liq6qhjs53g3iq0zkvz5wkvliqas4ha56";
  });
  haddock-api = overrideCabal super.haddock-api (drv: {
    version = "2.16.0";
    sha256 = "0hk42w6fbr6xp8xcpjv00bhi9r75iig5kp34vxbxdd7k5fqxr1hj";
  });
  haddock = overrideCabal super.haddock (drv: {
    version = "2.16.0";
    sha256 = "1afb96w1vv3gmvha2f1h3p8zywpdk8dfk6bgnsa307ydzsmsc3qa";
  });

  # Upstream was notified about the over-specified constraint on 'base'
  # but refused to do anything about it because he "doesn't want to
  # support a moving target". Go figure.
  barecheck = doJailbreak super.barecheck;

  syb-with-class = appendPatch super.syb-with-class (pkgs.fetchpatch {
    url = "https://github.com/seereason/syb-with-class/compare/adc86a9...719e567.patch";
    sha256 = "1lwwvxyhxcmppdapbgpfhwi7xc2z78qir03xjrpzab79p2qyq7br";
  });

  wl-pprint = overrideCabal super.wl-pprint (drv: {
    patchPhase = "sed -i '113iimport Prelude hiding ((<$>))' Text/PrettyPrint/Leijen.hs";
  });

  wl-pprint-text = overrideCabal super.wl-pprint-text (drv: {
    patchPhase = ''
      sed -i '71iimport Prelude hiding ((<$>))' Text/PrettyPrint/Leijen/Text/Monadic.hs
      sed -i '119iimport Prelude hiding ((<$>))' Text/PrettyPrint/Leijen/Text.hs
    '';
  });

  # https://github.com/kazu-yamamoto/unix-time/issues/30
  unix-time = dontCheck super.unix-time;

  # Until the changes have been pushed to Hackage
  haskell-src-meta = overrideCabal (doJailbreak (appendPatch super.haskell-src-meta ./haskell-src-meta-ghc710.patch)) (drv: {
    prePatch = "sed -i -e 's|template-haskell [^,]\\+|template-haskell|' haskell-src-meta.cabal && cat haskell-src-meta.cabal";
  });
  foldl = appendPatch super.foldl (pkgs.fetchpatch {
    url = "https://github.com/Gabriel439/Haskell-Foldl-Library/pull/30.patch";
    sha256 = "0q4gs3xkazh644ff7qn2mp2q1nq3jq71x82g7iaacxclkiv0bphx";
  });
  persistent-template = appendPatch super.persistent-template (pkgs.fetchpatch {
    url = "https://github.com/yesodweb/persistent/commit/4d34960bc421ec0aa353d69fbb3eb0c73585db97.patch";
    sha256 = "1gphl0v87y2fjwkwp6j0bnksd0d9dr4pis6aw97rij477bm5mrvw";
    stripLen = 1;
  });
  mono-traversable = appendPatch super.mono-traversable (pkgs.fetchpatch {
    url = "https://github.com/snoyberg/mono-traversable/pull/68.patch";
    sha256 = "11hqf6hi3sc34wl0fn4rpigdf7wfklcjv6jwp8c3129yphg8687h";
  });
  conduit-combinators = appendPatch super.conduit-combinators (pkgs.fetchpatch {
    url = "https://github.com/fpco/conduit-combinators/pull/16.patch";
    sha256 = "0jpwpi3shdn5rms3lcr4srajbhhfp5dbwy7pl23c9kmlil3d9mk3";
  });
  wai-extra = appendPatch super.wai-extra (pkgs.fetchpatch {
    url = "https://github.com/yesodweb/wai/pull/339.patch";
    sha256 = "1rmz1ijfch143v7jg4d5r50lqq9r46zhcmdafq8p9g9pjxlyc590";
    stripLen = 1;
  });
  yesod-auth = appendPatch super.yesod-auth (pkgs.fetchpatch {
    url = "https://github.com/yesodweb/yesod/pull/941.patch";
    sha256 = "1fycvjfr1l9wa03k30bnppl3ns99lffh9kmp9r7sr8b6yiydcajq";
    stripLen = 1;
  });

  ghcjs-prim = self.callPackage ({ mkDerivation, fetchgit, primitive }: mkDerivation {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "ca08e46257dc276e01d08fb47a693024bae001fa"; # ghc-7.10 branch
      sha256 = "0w7sqzp5p70yhmdhqasgkqbf3b61wb24djlavwil2j8ry9y472w3";
    };
    buildDepends = [ primitive ];
    license = pkgs.stdenv.lib.licenses.bsd3;
  }) {};
}
