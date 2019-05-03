{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 7.x.
  llvmPackages = pkgs.llvmPackages_7;

  # Disable GHC 8.8.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
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
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # Use our native version of the Cabal library.
  cabal-install = (doJailbreak super.cabal-install).overrideScope (self: super: { Cabal = null; });

  # Ignore overly restrictive upper version bounds.
  cryptohash-sha256 = doJailbreak super.cryptohash-sha256;
  doctest = doJailbreak super.doctest;
  split = doJailbreak super.split;
  test-framework = doJailbreak super.test-framework;
  hashable = doJailbreak super.hashable;
  async = doJailbreak super.async;

  # These packages don't work and need patching and/or an update.
  primitive = overrideSrc (doJailbreak super.primitive) {
    version = "20180530-git";
    src = pkgs.fetchFromGitHub {
      owner = "haskell";
      repo = "primitive";
      rev = "97964182881aa0419546e0bb188b2d17e4468324";
      sha256 = "1p1pinca33vd10iy7hl20c1fc99vharcgcai6z3ngqbq50k2pd3q";
    };
  };
  tar = overrideCabal (appendPatch super.tar (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/tar-0.5.1.0.patch";
    sha256 = "1inbfpamfdpi3yfac59j5xpaq5fvh5g1ca8hlbpic1bizd3s03i0";
  })) (drv: {
    configureFlags = ["-f-old-time"];
    editedCabalFile = null;
    preConfigure = ''
      cp -v ${pkgs.fetchurl {url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/tar-0.5.1.0.cabal"; sha256 = "1lydbwsmccf2av0g61j07bx7r5mzbcfgwvmh0qwg3a91857x264x";}} tar.cabal
      sed -i -e 's/time < 1.9/time < 2/' tar.cabal
    '';
  });
  resolv = overrideCabal (overrideSrc super.resolv {
    version = "20180411-git";
    src = pkgs.fetchFromGitHub {
      owner = "haskell-hvr";
      repo = "resolv";
      rev = "a22f9dd900cb276b3dd70f4781fb436d617e2186";
      sha256 = "1j2jyywmxjhyk46kxff625yvg5y37knv7q6y0qkwiqdwdsppccdk";
    };
  }) (drv: {
    buildTools = with pkgs; [autoconf];
    preConfigure = "autoreconf --install";
  });
  colour = appendPatch super.colour (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/colour-2.3.4.patch";
    sha256 = "1h318dczml9qrmfvlz1d12iji86klaxvz63k9g9awibwz8lw2i79";
  });
  dlist = appendPatch super.dlist (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/dlist-0.8.0.6.patch";
    sha256 = "0lkhibfxfk6mi796mrjgmbb50hbyjgc7xdinci64dahj8325jlpc";
  });
  QuickCheck = appendPatch super.QuickCheck (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/QuickCheck-2.13.1.patch";
    sha256 = "138yrp3x5cnvncimrnhnkawz6clyk7fj3sr3y93l5szfr11kcvbl";
  });
  regex-base = appendPatch super.regex-base (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/regex-base-0.93.2.patch";
    sha256 = "01d1plrdx6hcspwn2h6y9pyi5366qk926vb5cl5qcl6x4m23l6y1";
  });
  regex-posix = appendPatch super.regex-posix (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/regex-posix-0.95.2.patch";
    sha256 = "006yli58jpqp786zm1xlncjsilc38iv3a09r4pv94l587sdzasd2";
  });
  exceptions = appendPatch (doJailbreak super.exceptions) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/exceptions-0.10.1.patch";
    sha256 = "0427jg027dcckiy21zk29c49fzx4q866rqbabmh4wvqwwkz8yk37";
  });
  th-abstraction = appendPatch (doJailbreak super.th-abstraction) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/th-abstraction-0.2.11.0.patch";
    sha256 = "0czqfszfblz6bvsybcd1z5jijj79f9czqq6dn992wp2gibsbrgj3";
  });
  logict = appendPatch (doJailbreak super.logict) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/logict-0.6.0.2.patch";
    sha256 = "0my2n0r9pb35994q0xka96fv5jdpjdfwqppi5lily3rgzkajsixn";
  });
  zlib = appendPatch super.zlib (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/zlib-0.6.2.patch";
    sha256 = "13fy730z9ihyc9kw3qkh642mi0bdbd7bz01dksj1zz845pr9jjif";
  });
  optparse-applicative = appendPatch super.optparse-applicative (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/optparse-applicative-0.14.3.0.patch";
    sha256 = "068sjj98jqiq3h8h03mg4w2pa11q8lxkx2i4lmxivq77xyhlwq3y";
  });
  HTTP = appendPatch (doJailbreak super.HTTP) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/HTTP-4000.3.13.patch";
    sha256 = "1fadi529x7dnmbfmls5969qfn9d4z954nc4lbqxmrwgirphkpmn4";
  });
  hackage-security = appendPatch (doJailbreak super.hackage-security) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/hackage-security-0.5.3.0.patch";
    sha256 = "0l8x0pbsn18fj5ak5q0g5rva4xw1s9yc4d86a1pfyaz467b9i5a4";
  });

}
