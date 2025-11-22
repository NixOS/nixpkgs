{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs) lib;

  # Sometimes revisions are awkward to patch due to DOS line endings.
  ignoreRevisions =
    p:
    overrideCabal {
      editedCabalFile = null;
      revision = null;
    } p;

  # mhs has its own versions of some packages
  renamePackage =
    pname: pkg:
    overrideCabal (old: {
      inherit pname;
      inherit (pkg) src;

      postPatch = ''
        ${old.postPatch or ""}
        sed -e 's/name: \*${old.pname}/name: ${pname}/' ${old.pname}.cabal > ${pname}.cabal
        rm ${old.pname}.cabal
      '';
    }) pkg;

in

self: super:
{
  # Disable MicroHs core libraries
  array = null;
  base = null;
  bytestring = null;
  deepseq = null;
  directory = null;
  process = null;
  text = null;
  MicroHs = null;

  # Bootstrap MicroCabal
  MicroCabal = self.mkDerivation {
    pname = "MicroCabal";
    version = self.ghc.microcabal-stage1.version;
    src = self.ghc.microcabal-stage1.src;
    isLibrary = false;
    isExecutable = true;
    executableHaskellDepends = with self; [ base ];
    inherit (self.ghc.microcabal-stage1.meta)
      description
      homepage
      license
      mainProgram
      maintainers
      ;
  };

  # hackage-packages does not include GHC core libraries
  array-mhs = markUnbroken super.array-mhs;
  binary = self.binary_0_8_9_3;
  Cabal = self.Cabal_3_16_0_0;
  Cabal-syntax = self.Cabal-syntax_3_16_0_0;
  containers = self.containers_0_8;
  exceptions = self.exceptions_0_10_10;
  filepath = self.filepath_1_5_4_0;
  ghc-bignum = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = self.haskeline_0_8_4_0;
  hpc = self.hpc_0_7_0_2;
  integer-gmp = self.integer-gmp_1_1;
  libiserv = null;
  mtl = appendPatches [
    (pkgs.fetchpatch {
      url = "https://github.com/haskell/mtl/commit/f2b6d233f3ab6595fd4a9db7e4f446e21e937d8c.patch";
      name = "revert-polykinded-cont.patch";
      includes = [ "Control/Monad/Cont/Class.hs" ];
      revert = true;
      hash = "sha256-ZhH4Qkil1lHhqSmnwiUw5caOPyvX9uhHQvsovoI74Q4=";
    })
  ] self.mtl_2_3_1;
  os-string = self.os-string_2_0_8;
  parsec = self.parsec_3_1_18_0;
  pretty = self.pretty_1_1_3_6;
  rts = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  terminfo = self.terminfo_0_4_1_7;
  time = self.time_1_15;
  transformers = self.transformers_0_6_2_0;
  unix = self.unix_2_8_7_0;
  xhtml = self.xhtml_3000_4_0_0;
}
// lib.optionalAttrs (lib.versionAtLeast super.ghc.version "0.14.17.0") {
  # array-related modules were moved from base to array-mhs
  array = renamePackage "array" self.array-mhs;
}
