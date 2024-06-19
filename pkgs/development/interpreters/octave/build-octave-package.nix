# Generic builder for GNU Octave libraries.
# This is a file that contains nested functions. The first, outer, function
# is the library- and package-wide details, such as the nixpkgs library, any
# additional configuration provided, and the namePrefix to use (based on the
# pname and version of Octave), the octave package, etc.

{ lib
, stdenv
, config
, octave
, texinfo
, computeRequiredOctavePackages
, writeRequiredOctavePackagesHook
}:

# The inner function contains information required to build the individual
# libraries.
{ fullLibName ? "${attrs.pname}-${attrs.version}"

, src

, dontPatch ? false
, patches ? []
, patchPhase ? ""

, enableParallelBuilding ? true
# Build-time dependencies for the package, which were compiled for the system compiling this.
, nativeBuildInputs ? []

# Build-time dependencies for the package, which may not have been compiled for the system compiling this.
, buildInputs ? []

# Propagate build dependencies so in case we have A -> B -> C,
# C can import package A propagated by B
# Run-time dependencies for the package.
, propagatedBuildInputs ? []

# Octave packages that are required at runtime for this one.
# These behave similarly to propagatedBuildInputs, where if
# package A is needed by B, and C needs B, then C also requires A.
# The main difference between these and propagatedBuildInputs is
# during the package's installation into octave, where all
# requiredOctavePackages are ALSO installed into octave.
, requiredOctavePackages ? []

, preBuild ? ""

, meta ? {}

, passthru ? {}

, ... } @ attrs:

let
  requiredOctavePackages' = computeRequiredOctavePackages requiredOctavePackages;

  # Must use attrs.nativeBuildInputs before they are removed by the removeAttrs
  # below, or everything fails.
  nativeBuildInputs' = [
    octave
    writeRequiredOctavePackagesHook
  ]
  ++ nativeBuildInputs;

  passthru' = {
    updateScript = [
      ../../../../maintainers/scripts/update-octave-packages
      (builtins.unsafeGetAttrPos "pname" octave.pkgs.${attrs.pname}).file
    ];
  }
  // passthru;

  # This step is required because when
  # a = { test = [ "a" "b" ]; }; b = { test = [ "c" "d" ]; };
  # (a // b).test = [ "c" "d" ];
  # This used to mean that if a package defined extra nativeBuildInputs, it
  # would override the ones for building an Octave package (the hook and Octave
  # itself, causing everything to fail.
  attrs' = builtins.removeAttrs attrs [ "nativeBuildInputs" "passthru" ];

in stdenv.mkDerivation ({
  packageName = "${fullLibName}";
  # The name of the octave package ends up being
  # "octave-version-package-version"
  name = "${octave.pname}-${octave.version}-${fullLibName}";

  # This states that any package built with the function that this returns
  # will be an octave package. This is used for ensuring other octave
  # packages are installed into octave during the environment building phase.
  isOctavePackage = true;

  OCTAVE_HISTFILE = "/dev/null";

  inherit src;

  inherit dontPatch patches patchPhase;

  dontConfigure = true;

  enableParallelBuilding = enableParallelBuilding;

  requiredOctavePackages = requiredOctavePackages';

  nativeBuildInputs = nativeBuildInputs';

  buildInputs = buildInputs ++ requiredOctavePackages';

  propagatedBuildInputs = propagatedBuildInputs ++ [ texinfo ];

  preBuild = if preBuild == "" then
    ''
      # This trickery is needed because Octave expects a single directory inside
      # at the top-most level of the tarball.
      tar --transform 's,^,${fullLibName}/,' -cz * -f ${fullLibName}.tar.gz
    ''
             else
               preBuild;

  buildPhase = ''
    runHook preBuild

    mkdir -p $out
    octave-cli --eval "pkg build $out ${fullLibName}.tar.gz"

    runHook postBuild
  '';

  # We don't install here, because that's handled when we build the environment
  # together with Octave.
  dontInstall = true;

  passthru = passthru';

  inherit meta;
} // attrs')
