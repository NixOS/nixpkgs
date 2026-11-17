# GHC 6.2.2, the first GHC with an x86-64 port (unregisterised, via C).
#
# Stage 1 is the compiler proper compiled by MicroHs.  It runs on the MicroHs
# runtime, about twenty times slower than a native compiler, so it compiles
# base and haskell98 and then the compiler again module by module (stage 2,
# native).  The runtime system is compiled with gcc alone.  Stages 3 to 5
# recompile the compiler with the stage before, and stage 5's C output must be
# identical to stage 4's (passthru.tests.fixpoint).  Finally GHC 6.2.2's own
# configure and make build the installed compiler, with stage 3 as the
# bootstrapping compiler.
{
  lib,
  newScope,
  runCommandCC,
  ghc-bootstrap-src,
  happy,
  gmp,
}:

let
  stages = lib.makeScope newScope (self: {
    tree = self.callPackage ./tree.nix { };
    rts = self.callPackage ./rts.nix { };
    stage1 = self.callPackage ./stage1.nix { };
    base = self.callPackage ./base.nix { };
    stage2 = self.callPackage ./stage2.nix { };
    stage3 = self.callPackage ./native.nix {
      stage = 3;
      compiler = self.stage2;
    };
    stage4 = self.callPackage ./native.nix {
      stage = 4;
      compiler = self.stage3;
    };
    stage5 = self.callPackage ./native.nix {
      stage = 5;
      compiler = self.stage4;
      link = false;
    };
    fixpoint = self.callPackage ./fixpoint.nix { };
    boot = self.callPackage ./boot.nix { };
    inst = self.callPackage ./inst.nix { };
  });

  ghc = stages.inst.overrideAttrs (old: {
    passthru = old.passthru or { } // {
      inherit (stages)
        tree
        rts
        stage1
        base
        stage2
        stage3
        stage4
        stage5
        fixpoint
        boot
        ;
      inherit happy gmp;
      tests = {
        inherit (stages) fixpoint;
        # The installed compiler on its own, with the default cc-wrapper settings
        hello = runCommandCC "ghc-6.2.2-test-hello" { nativeBuildInputs = [ ghc ]; } ''
          cp ${ghc-bootstrap-src}/ghc622/test/Hello.hs ${ghc-bootstrap-src}/common/test/GmpZero.hs .
          ghc -v0 --make Hello.hs -o hello
          ./hello
          ghc -v0 -O --make GmpZero.hs -o gmp-zero
          [ "$(./gmp-zero)" = "(2400000,0)" ]
          touch "$out"
        '';
      };
    };
  });
in
ghc
