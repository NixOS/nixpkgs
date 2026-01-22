{
  version,
  mcabalVersion ? "0.5.3.0-31f1b5dec81561a1b1d36b8e3065ce091dce2ec6",
  rev ? "refs/tags/v${version}",
  hash,
}:

{
  lib,
  buildPackages,
  pkgsBuildBuild,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  microhs-boot,
  stdenv,
  writeShellScript,
}:

let
  args = finalAttrs: {
    inherit version;

    src = fetchFromGitHub {
      owner = "augustss";
      repo = "MicroHs";
      fetchSubmodules = true;
      inherit rev hash;
    };

    patches = [
      # https://github.com/augustss/MicroHs/pull/333
      (fetchpatch {
        name = "fix-missing-sources.patch";
        url = "https://github.com/AlexandreTunstall/MicroHs/commit/081d9d852c12cb58b91cf6ea8dd6038bffed94f8.patch";
        hash = "sha256-e2kV5yqi2iVduF7XPWD7o+bDRZRApX2jYAwzrIlCpI8=";
      })
    ];

    # The source contains pre-compiled files
    # We delete them to be certain we are building from source
    postPatch = ''
      rm -r generated
    '';

    meta = {
      description = "Small compiler for Haskell";
      longDescription = ''
        A compiler for an extended subset of Haskell 2010.
        The compiler translates to combinators and can compile itself.
      '';
      homepage = "https://github.com/augustss/MicroHs";
      license = lib.licensesSpdx."Apache-2.0";
      mainProgram = "mhs";
      maintainers = with lib.maintainers; [
        AlexandreTunstall
        steeleduncan
      ];
      platforms = lib.platforms.all;
    };
  };

  microhs-stage1-build = pkgsBuildBuild.callPackage ./stage1.nix {
    inherit args microhs-boot;
  };

  microhs-stage1 = buildPackages.callPackage ./stage1.nix {
    inherit args microhs-boot;
  };

  microhs-stage2 = callPackage ./stage2.nix {
    inherit
      args
      microcabal-stage1
      microhs-stage1
      cpphs
      ;
  };

  microcabal-stage1 = buildPackages.callPackage ../../tools/haskell/microcabal/${mcabalVersion}.nix {
    microhs = microhs-stage1-build;
  };

  cpphs = buildPackages.callPackage ./cpphs.nix {
    inherit args;
    microhs = microhs-stage2;
  };

in
microhs-stage2
