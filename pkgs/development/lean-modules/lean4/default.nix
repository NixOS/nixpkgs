# Lean 4 toolchain for the leanPackages set (independent of pkgs.lean4).
{
  lib,
  stdenv,
  symlinkJoin,
  cmake,
  cctools,
  fetchFromGitHub,
  fetchpatch,
  git,
  gmp,
  cadical,
  cadical' ? cadical.override { version = "2.1.3"; },
  leangz,
  openssl,
  pkg-config,
  libuv,
  perl,
  runCommand,
  writeText,
  testers,
}:

let
  lean4 = stdenv.mkDerivation (finalAttrs: {
    pname = "lean4";
    version = "4.33.0";

    mimalloc-src = fetchFromGitHub {
      owner = "microsoft";
      repo = "mimalloc";
      tag = "v2.2.3";
      hash = "sha256-B0gngv16WFLBtrtG5NqA2m5e95bYVcQraeITcOX9A74=";
    };

    src = fetchFromGitHub {
      owner = "leanprover";
      repo = "lean4";
      tag = "v${finalAttrs.version}";
      hash = "sha256-avTsPLjouuxejTb1kVqbNbhI9CKZuqhGINAy3TaRNcE=";
    };

    patches = [
      # `lean_alloc_small_object` handles sizes up to 4096, but passes them to `mi_malloc_small`,
      # which is only valid up to `MI_SMALL_SIZE_MAX` (1024), corrupting the heap and making `lean`
      # segfault at random (e.g. while building mathlib):
      # https://github.com/leanprover/lean4/issues/14148
      # Fixed upstream in https://github.com/leanprover/lean4/pull/7786, after the 4.33.0 cut.
      (fetchpatch {
        name = "mi_malloc_small-size-overflow.patch";
        url = "https://github.com/leanprover/lean4/commit/171f24d1c7ca8a24ce8a7b305330c33ead7a08df.patch";
        excludes = [ "CMakeLists.txt" ];
        hash = "sha256-KcXtyogTUE6ri+Scdxkw1Zv/XnWZcMGutUpwCvR1EmM=";
      })
      # `ST.Ref.swap` racing against `ST.Ref.get` decrements the wrong object, freeing it while it
      # is still referenced. Same symptom as above, but only under heavy parallelism:
      # https://github.com/leanprover/lean4/issues/14584
      (fetchpatch {
        name = "st-ref-swap-cas.patch";
        url = "https://github.com/leanprover/lean4/commit/8f0ceabca35e829d3be972645b6b29d4ddfb4ee8.patch";
        hash = "sha256-P8o1IV4x8v3DzNl5SX/XFbdlsdb5YiI5YTH2UeWCutk=";
      })
    ]
    # The prebuilt bootstrap compiler in `stage0` carries its own copy of the runtime, and hits both
    # bugs above while building stage1, so it needs them too.
    ++ [
      (fetchpatch {
        name = "mi_malloc_small-size-overflow-stage0.patch";
        url = "https://github.com/leanprover/lean4/commit/171f24d1c7ca8a24ce8a7b305330c33ead7a08df.patch";
        relative = "src";
        extraPrefix = "stage0/src/";
        hash = "sha256-/jxBVn6i59aDCvJWDqzu3OHxcOkDIka/FPhzvRGY/IU=";
      })
      (fetchpatch {
        name = "st-ref-swap-cas-stage0.patch";
        url = "https://github.com/leanprover/lean4/commit/8f0ceabca35e829d3be972645b6b29d4ddfb4ee8.patch";
        relative = "src";
        extraPrefix = "stage0/src/";
        hash = "sha256-oivqD35FwPokjDt7tZ3Id8z8sEGYA49CzEGcwb9fAJ0=";
      })
    ];

    # Vendor mimalloc. Upstream has since partially adopted FetchContent:
    # https://github.com/leanprover/lean4/commit/a145b9c11a0fe38fd4c921024a7376c99cc34bd2
    #
    # Dynamically adjust the source tree to maintain a healthy boundary
    # with Nix and avoid overstepping on its jurisdiction over cache coherence.
    postPatch =
      let
        pattern = "\${LEAN_BINARY_DIR}/../mimalloc/src/mimalloc";
      in
      ''
        for file in stage0/src/CMakeLists.txt stage0/src/runtime/CMakeLists.txt src/CMakeLists.txt src/runtime/CMakeLists.txt; do
          substituteInPlace "$file" \
            --replace-fail '${pattern}' '${finalAttrs.mimalloc-src}'
        done

        substituteInPlace src/lake/Lake/Load/Lean/Elab.lean \
          --replace-fail \
            'let upToDate := (← olean.pathExists) ∧' \
            'let upToDate := cfg.pkgDir.toString.startsWith "/nix/store/" ∨ (← olean.pathExists) ∧'
      '';

    preConfigure = ''
      patchShebangs stage0/src/bin/ src/bin/
    '';

    nativeBuildInputs = [
      cmake
      leangz
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools.libtool ];

    buildInputs = [
      gmp
      libuv
      cadical'
      openssl
    ];

    nativeCheckInputs = [
      git
      perl
    ];

    cmakeFlags = [
      "-DUSE_GITHASH=OFF"
      "-DINSTALL_LICENSE=OFF"
      "-DINSTALL_CADICAL=OFF"
      "-DINSTALL_LEANTAR=OFF"
      "-DUSE_MIMALLOC=ON"
      "-DFETCHCONTENT_SOURCE_DIR_MIMALLOC=${finalAttrs.mimalloc-src}"
    ];

    passthru.tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = "v${finalAttrs.version}";
      };
    };

    meta = {
      description = "Automatic and interactive theorem prover";
      homepage = "https://leanprover.github.io/";
      changelog = "https://github.com/leanprover/lean4/blob/${finalAttrs.src.tag}/RELEASES.md";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ nadja-y ];
      mainProgram = "lean";
    };
  });

  oldStorePath = builtins.substring 0 43 (toString lean4);

  # Binary-patched for correct runtime discovery in wrapped environments.
  wrapped = symlinkJoin {
    inherit (lean4) name pname;
    paths = [
      lean4
      cadical'
      leangz
    ];
    nativeBuildInputs = [ perl ];
    postBuild = ''
      newStorePath=$(echo "$out" | head -c 43)

      for bin in ${lean4}/bin/*; do
        test -f "$bin" || continue
        install -m755 "$bin" "$out/bin/"
        perl -pi -e "s|\Q${oldStorePath}\E|$newStorePath|g" "$out/bin/$(basename "$bin")"
      done
    '';

    inherit (lean4) version src meta;
    passthru = {
      inherit (lean4) version src;
      tests =
        let
          src = writeText "smoke.lean" ''
            import Std
            example : 1 + 1 = 2 := by decide
            example : ∀ (x y : BitVec 8), x &&& y = y &&& x := by bv_decide
          '';
        in
        {
          version = testers.testVersion {
            package = wrapped;
            version = "v${lean4.version}";
          };
          smoke = runCommand "lean4-test-smoke" { } ''
            ${wrapped}/bin/lean ${src}
            touch $out
          '';
        };
    };
  };
in
wrapped
