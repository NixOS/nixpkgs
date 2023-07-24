{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch lib;
  checkAgainAfter = pkg: ver: msg: act:
    if builtins.compareVersions pkg.version ver <= 0 then act
    else
      builtins.throw "Check if '${msg}' was resolved in ${pkg.pname} ${pkg.version} and update or remove this";
in

with haskellLib;
self: super: let
  jailbreakForCurrentVersion = p: v: checkAgainAfter p v "bad bounds" (doJailbreak p);
in {
  llvmPackages = lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  Cabal-syntax = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
  filepath = null;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  libiserv = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else self.xhtml_3000_3_0_0;

  # consequences of doctest breakage follow:

  ghc-source-gen = checkAgainAfter super.ghc-source-gen "0.4.3.0" "fails to build" (markBroken super.ghc-source-gen);

  # Jailbreaks & Version Updates

  hashable-time = doJailbreak super.hashable-time;
  libmpd = doJailbreak super.libmpd;
  # generically needs base-orphans for 9.4 only
  base-orphans = dontCheck (doDistribute super.base-orphans);

  # the dontHaddock is due to a GHC panic. might be this bug, not sure.
  # https://gitlab.haskell.org/ghc/ghc/-/issues/21619
  hedgehog = dontHaddock super.hedgehog;

  hpack = overrideCabal (drv: {
    # Cabal 3.6 seems to preserve comments when reading, which makes this test fail
    # 2021-10-10: 9.2.1 is not yet supported (also no issue)
    testFlags = [
      "--skip=/Hpack/renderCabalFile/is inverse to readCabalFile/"
    ] ++ drv.testFlags or [];
  }) (doJailbreak super.hpack);

  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  }) (doJailbreak super.language-haskell-extract);

  # Tests depend on `parseTime` which is no longer available
  hourglass = dontCheck super.hourglass;

  # https://github.com/sjakobi/bsb-http-chunked/issues/38
  bsb-http-chunked = dontCheck super.bsb-http-chunked;

  # 2022-08-01: Tests are broken on ghc 9.2.4: https://github.com/wz1000/HieDb/issues/46
  hiedb = dontCheck super.hiedb;

  # 2022-10-06: https://gitlab.haskell.org/ghc/ghc/-/issues/22260
  ghc-check = dontHaddock super.ghc-check;

  # Too strict upper bound on template-haskell
  # https://github.com/mokus0/th-extras/issues/18
  th-extras = doJailbreak super.th-extras;

  # requires newer versions to work with GHC 9.4
  servant = doJailbreak super.servant;
  servant-server = doJailbreak super.servant-server;
  servant-auth = doJailbreak super.servant-auth;
  servant-auth-swagger = doJailbreak super.servant-auth-swagger;
  servant-swagger = doJailbreak super.servant-swagger;
  servant-client-core = doJailbreak super.servant-client-core;
  servant-client = doJailbreak super.servant-client;
  # https://github.com/kowainik/relude/issues/436
  relude = dontCheck super.relude;

  fourmolu = overrideCabal (drv: {
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [ self.file-embed ];
  }) (disableCabalFlag "fixity-th" super.fourmolu);

  # Apply workaround for Cabal 3.8 bug https://github.com/haskell/cabal/issues/8455
  # by making `pkg-config --static` happy. Note: Cabal 3.9 is also affected, so
  # the GHC 9.6 configuration may need similar overrides eventually.
  X11-xft = __CabalEagerPkgConfigWorkaround super.X11-xft;
  # Jailbreaks for https://github.com/gtk2hs/gtk2hs/issues/323#issuecomment-1416723309
  glib = __CabalEagerPkgConfigWorkaround (doJailbreak super.glib);
  cairo = __CabalEagerPkgConfigWorkaround (doJailbreak super.cairo);
  pango = __CabalEagerPkgConfigWorkaround (doJailbreak super.pango);

  # Cabal 3.8 bug workaround for haskell-gi family of libraries
  gi-atk = __CabalEagerPkgConfigWorkaround super.gi-atk;
  gi-cairo = __CabalEagerPkgConfigWorkaround super.gi-cairo;
  gi-gdk = __CabalEagerPkgConfigWorkaround super.gi-gdk;
  gi-gdkpixbuf = __CabalEagerPkgConfigWorkaround super.gi-gdkpixbuf;
  gi-gio = __CabalEagerPkgConfigWorkaround super.gi-gio;
  gi-glib = __CabalEagerPkgConfigWorkaround super.gi-glib;
  gi-gmodule = __CabalEagerPkgConfigWorkaround super.gi-gmodule;
  gi-gobject = __CabalEagerPkgConfigWorkaround super.gi-gobject;
  gi-gtk = __CabalEagerPkgConfigWorkaround super.gi-gtk;
  gi-harfbuzz = __CabalEagerPkgConfigWorkaround super.gi-harfbuzz;
  gi-pango = __CabalEagerPkgConfigWorkaround super.gi-pango;
  gi-vte = __CabalEagerPkgConfigWorkaround super.gi-vte;
  haskell-gi = __CabalEagerPkgConfigWorkaround super.haskell-gi;
  haskell-gi-base = __CabalEagerPkgConfigWorkaround super.haskell-gi-base;
  svgcairo = __CabalEagerPkgConfigWorkaround super.svgcairo;
  gtk3 = __CabalEagerPkgConfigWorkaround super.gtk3;
  webkit2gtk3-javascriptcore = __CabalEagerPkgConfigWorkaround super.webkit2gtk3-javascriptcore;
  gi-javascriptcore = __CabalEagerPkgConfigWorkaround super.gi-javascriptcore;
  gi-soup = __CabalEagerPkgConfigWorkaround super.gi-soup;
  gio = __CabalEagerPkgConfigWorkaround super.gio;
  gtk = __CabalEagerPkgConfigWorkaround super.gtk;

  # Cabal 3.8 bug workaround for applications using haskell-gi family of libraries
  termonad = __CabalEagerPkgConfigWorkaround super.termonad;
}
