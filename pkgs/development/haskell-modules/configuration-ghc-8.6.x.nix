{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 5.x.
  llvmPackages = pkgs.llvmPackages_5;

  # Disable GHC 8.6.x core libraries.
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

  # Use to be a core-library, but no longer is since GHC 8.4.x.
  hoopl = self.hoopl_3_10_2_2;

  # LTS-12.x versions do not compile.
  base-orphans = self.base-orphans_0_8;
  contravariant = self.contravariant_1_5;
  free = self.free_5_1;
  haddock-library = dontCheck super.haddock-library_1_7_0;
  hpack = self.hpack_0_31_0;
  hspec = self.hspec_2_5_8;
  hspec-core = self.hspec-core_2_5_8;
  hspec-discover = self.hspec-discover_2_5_8;
  hspec-meta = self.hspec-meta_2_5_6;
  JuicyPixels = self.JuicyPixels_3_3_2;
  lens = self.lens_4_17;
  megaparsec = dontCheck super.megaparsec_7_0_1;
  neat-interpolation = dontCheck super.neat-interpolation_0_3_2_4;  # test suite depends on broken HTF
  patience = markBrokenVersion "0.1.1" super.patience;
  primitive = self.primitive_0_6_4_0;
  QuickCheck = self.QuickCheck_2_12_6_1;
  semigroupoids = self.semigroupoids_5_3_1;
  tagged = self.tagged_0_8_6;
  yaml = self.yaml_0_11_0_0;

  # https://github.com/tibbe/unordered-containers/issues/214
  unordered-containers = dontCheck super.unordered-containers;

  # https://github.com/haskell/fgl/issues/79
  # https://github.com/haskell/fgl/issues/81
  fgl = appendPatch super.fgl ./patches/fgl-monad-fail.patch;

  # Test suite does not compile.
  cereal = dontCheck super.cereal;
  Diff = dontCheck super.Diff;
  http-api-data = doJailbreak super.http-api-data;
  persistent-sqlite = dontCheck super.persistent-sqlite;
  psqueues = dontCheck super.psqueues;    # won't cope with QuickCheck 2.12.x
  system-fileio = dontCheck super.system-fileio;  # avoid dependency on broken "patience"
  unicode-transforms = dontCheck super.unicode-transforms;

  # https://github.com/bmillwood/haskell-src-meta/pull/80
  haskell-src-meta = doJailbreak super.haskell-src-meta;

  # The official 1.12 release is broken and unmaintained.
  polyparse = appendPatch (overrideCabal super.polyparse (drv: { editedCabalFile = null; })) (pkgs.fetchpatch {
    url = https://github.com/bergmark/polyparse/commit/8a69ee7e57db798c106d8b56dce05b1dfc4fed37.patch;
    sha256 = "11r73wx1w6bfrkrnk6r9k7rfzp6qrvkdikb2by37ld06c0w6nn57";
  });

  # https://github.com/skogsbaer/HTF/issues/69
  HTF = markBrokenVersion "0.13.2.4" super.HTF;

}
