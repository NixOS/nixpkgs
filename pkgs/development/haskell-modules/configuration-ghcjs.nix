{ pkgs }:

let
  removeLibraryHaskellDepends = pnames: depends:
    builtins.filter (e: !(builtins.elem (e.pname or "") pnames)) depends;
in

with import ./lib.nix { inherit pkgs; };

self: super:

  let # The stage 1 packages
      stage1 = pkgs.lib.genAttrs super.ghc.stage1Packages (pkg: null);
      # The stage 2 packages. Regenerate with ../compilers/ghcjs/gen-stage2.rb
      stage2 = super.ghc.mkStage2 {
        inherit (self) callPackage;
      };
  in stage1 // stage2 // {

  old-time = overrideCabal stage2.old-time (drv: {
    postPatch = ''
      ${pkgs.autoconf}/bin/autoreconf --install --force --verbose
    '';
    buildTools = pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.darwin.libiconv;
  });

  network = addBuildTools super.network (pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.darwin.libiconv);
  zlib = addBuildTools super.zlib (pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.darwin.libiconv);
  unix-compat = addBuildTools super.unix-compat (pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.darwin.libiconv);

  # LLVM is not supported on this GHC; use the latest one.
  inherit (pkgs) llvmPackages;

  inherit (self.ghc.bootPkgs)
    jailbreak-cabal alex happy gtk2hs-buildtools rehoo hoogle;

  # Don't set integer-simple to null!
  # GHCJS uses integer-gmp, so any package expression that depends on
  # integer-simple is wrong.
  #integer-simple = null;

  # These packages are core libraries in GHC 7.10.x, but not here.
  bin-package-db = null;
  haskeline = self.haskeline_0_7_2_1;
  hoopl = self.hoopl_3_10_2_1;
  hpc = self.hpc_0_6_0_2;
  terminfo = self.terminfo_0_4_0_1;
  xhtml = self.xhtml_3000_2_1;

  pqueue = overrideCabal super.pqueue (drv: {
    postPatch = ''
      sed -i -e '12s|null|Data.PQueue.Internals.null|' Data/PQueue/Internals.hs
      sed -i -e '64s|null|Data.PQueue.Internals.null|' Data/PQueue/Internals.hs
      sed -i -e '32s|null|Data.PQueue.Internals.null|' Data/PQueue/Min.hs
      sed -i -e '32s|null|Data.PQueue.Max.null|' Data/PQueue/Max.hs
      sed -i -e '42s|null|Data.PQueue.Prio.Internals.null|' Data/PQueue/Prio/Min.hs
      sed -i -e '42s|null|Data.PQueue.Prio.Max.null|' Data/PQueue/Prio/Max.hs
    '';
  });

  transformers-compat = overrideCabal super.transformers-compat (drv: {
    configureFlags = [];
  });

  profunctors = overrideCabal super.profunctors (drv: {
    preConfigure = ''
      sed -i 's/^{-# ANN .* #-}//' src/Data/Profunctor/Unsafe.hs
    '';
  });

  ghcjs-ffiqq = self.callPackage
    ({ mkDerivation, base, template-haskell, ghcjs-base, split, containers, text, ghc-prim
     }:
     mkDerivation {
       pname = "ghcjs-ffiqq";
       version = "0.1.0.0";
       src = pkgs.fetchFromGitHub {
         owner = "ghcjs";
         repo = "ghcjs-ffiqq";
         rev = "da31b18582542fcfceade5ef6b2aca66662b9e20";
         sha256 = "1mkp8p9hispyzvkb5v607ihjp912jfip61id8d42i19k554ssp8y";
       };
       libraryHaskellDepends = [
         base template-haskell ghcjs-base split containers text ghc-prim
       ];
       description = "FFI QuasiQuoter for GHCJS";
       license = stdenv.lib.licenses.mit;
     }) {};

  ghcjs-dom = overrideCabal super.ghcjs-dom (drv: {
    libraryHaskellDepends = [ self.ghcjs-base ] ++
      removeLibraryHaskellDepends [
        "glib" "gtk" "gtk3" "webkitgtk" "webkitgtk3"
      ] drv.libraryHaskellDepends;
  });

  ghc-paths = overrideCabal super.ghc-paths (drv: {
    patches = [ ./patches/ghc-paths-nix-ghcjs.patch ];
  });

  # reflex 0.3, made compatible with the newest GHCJS.
  reflex = overrideCabal super.reflex (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "ryantrinkle";
      repo = "reflex";
      rev = "cc62c11a6cde31412582758c236919d4bb766ada";
      sha256 = "1j4vw0636bkl46lj8ry16i04vgpivjc6bs3ls54ppp1wfp63q7w4";
    };
  });

  # reflex-dom 0.2, made compatible with the newest GHCJS.
  reflex-dom = overrideCabal super.reflex-dom (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "ryantrinkle";
      repo = "reflex-dom";
      rev = "639d9ca13c2def075e83344c9afca6eafaf24219";
      sha256 = "0166ihbh3dbfjiym9w561svpgvj0x4i8i8ws70xaafi0cmpsxrar";
    };
    libraryHaskellDepends =
      removeLibraryHaskellDepends [
        "glib" "gtk3" "webkitgtk3" "webkitgtk3-javascriptcore" "raw-strings-qq" "unix"
      ] drv.libraryHaskellDepends;
  });

}
