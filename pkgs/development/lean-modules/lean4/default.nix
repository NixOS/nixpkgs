# Lean 4 toolchain for the leanPackages set (independent of pkgs.lean4).
{
  lib,
  stdenv,
  symlinkJoin,
  cmake,
  fetchFromGitHub,
  git,
  gmp,
  cadical,
  cadical' ? cadical.override { version = "2.1.3"; },
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
    version = "4.29.1";

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
      hash = "sha256-pdhRPjSic2H8zPJXLmyfN8umKDoafjmSo4OQSRxIbyE=";
    };

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
        substituteInPlace src/CMakeLists.txt \
          --replace-fail 'set(GIT_SHA1 "")' 'set(GIT_SHA1 "${finalAttrs.src.tag}")'

        rm -rf src/lake/examples/git/

        substituteInPlace CMakeLists.txt \
          --replace-fail 'GIT_REPOSITORY https://github.com/microsoft/mimalloc' \
                         'SOURCE_DIR "${finalAttrs.mimalloc-src}"' \
          --replace-fail 'GIT_TAG ${finalAttrs.mimalloc-src.tag}' ""
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
      pkg-config
    ];

    buildInputs = [
      gmp
      libuv
      cadical'
    ];

    nativeCheckInputs = [
      git
      perl
    ];

    cmakeFlags = [
      "-DUSE_GITHASH=OFF"
      "-DINSTALL_LICENSE=OFF"
      "-DINSTALL_CADICAL=OFF"
      "-DUSE_MIMALLOC=ON"
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
