{
  pkgs,
  lib,
}:
let
  inherit (lib) addMetaAttrs;
  addToNativeBuildInputs = pkg: old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ lib.toList pkg;
  };
  addToBuildInputs = pkg: old: {
    buildInputs = (old.buildInputs or [ ]) ++ lib.toList pkg;
  };
  addPkgConfig = old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
  };
  addToBuildInputsWithPkgConfig = pkg: old: (addPkgConfig old) // (addToBuildInputs pkg old);
  addToCscOptions = opt: old: {
    env.CSC_OPTIONS = lib.concatStringsSep " " ([ old.env.CSC_OPTIONS or "" ] ++ lib.toList opt);
  };
  broken = addMetaAttrs { broken = true; };
in
{
  # Eggs binding to a native library.
  blas = addToBuildInputsWithPkgConfig pkgs.blas;
  breadline = addToBuildInputs pkgs.readline;
  espeak = addToBuildInputsWithPkgConfig pkgs.espeak-ng;
  ezxdisp = addToBuildInputsWithPkgConfig pkgs.libx11;
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  # The egg bundles the leptonica headers it needs, but not the library.
  leptonic = addToBuildInputs pkgs.leptonica;
  openssl = addToBuildInputs pkgs.openssl;
  postgresql = addToBuildInputsWithPkgConfig pkgs.libpq;

  # fltk-config has to be on PATH: the egg runs it to get its compiler flags.
  # Those flags include -lGL and -lGLU, which fltk does not pull in itself.
  bb =
    old:
    (addToBuildInputs [
      pkgs.fltk
      pkgs.libGL
      pkgs.libGLU
    ] old)
    // (addToNativeBuildInputs pkgs.fltk old);

  # The egg looks for the OpenCASCADE headers in /usr/{local/,}include/opencascade,
  # which the C compiler wrapper cannot make up for, as they are in a subdirectory
  # of the include path it is given.
  constructive-solid-geometry =
    old:
    (addToBuildInputs pkgs.opencascade-occt old)
    // (addToCscOptions "-C -I${lib.getDev pkgs.opencascade-occt}/include/opencascade" old);

  # Unlike the CHICKEN 5 egg, which hardcoded /usr/include/subversion-1, this one
  # asks pkg-config for everything.
  svn-client = addToBuildInputsWithPkgConfig [
    pkgs.subversion
    pkgs.apr
    pkgs.aprutil
  ];

  # Mark broken.
  # feathers is implemented in Tcl and its .egg declares no source for the
  # program it builds, so chicken-install falls back to a feathers.scm that the
  # tarball does not contain. It only fails here because the egg is built and
  # installed by two separate chicken-install runs. Upstream is deprecating it.
  feathers = broken;
}
