{
  lib,
  stdenv,
  runCommand,
  python,
  writableTmpDirAsHomeHook,
  xvfb-run,
  writeShellScriptBin,
  pkgs,
}:

let
  testRoot = ./.;
  fs = lib.fileset;

  testFiles = lib.pipe testRoot [
    (fs.fileFilter (file: file.hasExt "py"))
    (fs.toList)
  ];

  brokenTests = [ ];

  # /path/to/foo.py -> "foo"
  nameOf = file: lib.removeSuffix ".py" (lib.baseNameOf file);

  mkTest =
    file:
    runCommand "test-${nameOf file}"
      (
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
            ]
            ++ lib.optionals stdenv.hostPlatform.isDarwin [
              # pyvista runs `pgrep -qx Finder` on Darwin to detect a GUI session; without
              # pgrep in PATH it crashes with FileNotFoundError. Exit 1 signals Finder is
              # not running so it falls back to checking $DISPLAY / offscreen rendering.
              (writeShellScriptBin "pgrep" "exit 1")
            ];

          env.EMERGE_MP_SOLVER = lib.optionalString python.pkgs.emerge.cudaSupport "CUDSS";

          meta.broken = lib.elem file brokenTests;
        }
        // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
          # Cocoa VTK requires WindowServer / GPU access for OpenGL context creation
          __noChroot = true;
        }
      )
      ''
        ${lib.optionalString (!stdenv.hostPlatform.isDarwin) "xvfb-run "}python ${file}
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
