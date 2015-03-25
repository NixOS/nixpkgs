{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

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

  # Upstream was notified about the over-specified constraint on 'base'
  # but refused to do anything about it because he "doesn't want to
  # support a moving target". Go figure.
  barecheck = doJailbreak super.barecheck;
  cartel = overrideCabal super.cartel (drv: { doCheck = false; patchPhase = "sed -i -e 's|base >= .*|base|' cartel.cabal"; });

  # https://github.com/kazu-yamamoto/unix-time/issues/30
  unix-time = dontCheck super.unix-time;

  # Until the changes have been pushed to Hackage
  haskell-src-meta = appendPatch super.haskell-src-meta (pkgs.fetchpatch {
    url = "https://github.com/bmillwood/haskell-src-meta/pull/31.patch";
    sha256 = "0ij5zi2sszqns46mhfb87fzrgn5lkdv8yf9iax7cbrxb4a2j4y1w";
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
  stringsearch = appendPatch super.stringsearch (pkgs.fetchpatch {
    url = "https://bitbucket.org/api/2.0/repositories/dafis/stringsearch/pullrequests/3/patch";
    sha256 = "13n7wipaa1j2rghg2j68yjnda8a5galpv5sfz4j4d9509xakz25g";
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
}
