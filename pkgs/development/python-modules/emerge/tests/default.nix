{
  lib,
  runCommand,
  python,
  writableTmpDirAsHomeHook,
  xvfb-run,
  pkgs,
}:

let
  testRoot = ./.;
  fs = lib.fileset;

  testFiles = lib.pipe testRoot [
    (fs.fileFilter (file: file.hasExt "py"))
    (fs.toList)
  ];

  brokenTests = [
    # FIX:
    # scipy.sparse.linalg._eigen.arpack.arpack.ArpackNoConvergence: ARPACK
    # error -1: No convergence (20221 iterations, 1/3 eigenvectors converged)
    ./resonant-cavity.py
  ];

  # /path/to/foo.py -> "foo"
  nameOf = file: lib.removeSuffix ".py" (lib.baseNameOf file);

  mkTest =
    file:
    runCommand "test-${nameOf file}"
      {
        nativeBuildInputs =
          let
            pyEnv = python.withPackages (ps: with ps; [ emerge ]);

            # Since we're calling this file using python's `callPackage`, it tries to use
            # `python3Packages.mesa` rather than the toplevel one. However, the former has
            # been removed because it's broken.
            #
            # As a workaround, we're getting the toplevel `mesa` through `pkgs`.
            mesa = pkgs.mesa;
          in
          [
            pyEnv
            writableTmpDirAsHomeHook
            xvfb-run
            mesa.llvmpipeHook # OpenGL context
          ];

        env.EMERGE_MP_SOLVER = lib.optionalString python.pkgs.emerge.cudaSupport "CUDSS";
        env.NUMBA_DISABLE_JIT = 1; # quite slow and won't be cached anyways

        meta.broken = lib.elem file brokenTests;
      }
      ''
        xvfb-run python ${file}
        mkdir -p $out
        cp *.png $out
      '';

  testAttrs = lib.listToAttrs (
    map (file: {
      name = nameOf file;
      value = mkTest file;
    }) testFiles
  );
in
testAttrs
