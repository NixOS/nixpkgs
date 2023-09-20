# Type Aliases
#
# See ./extension.nix:
# - ReleaseAttrs
# - ReleaseFeaturesAttrs
#
# General callPackage-supplied arguments
{ lib
, stdenv
, backendStdenv
, fetchurl
, autoPatchelfHook
, autoAddOpenGLRunpathHook
, markForCudatoolkitRootHook
, lndir
, symlinkJoin
}:
# Function arguments
{
  # Short package name (e.g., "cuda_cccl")
  # pname : String
  pname
, # Long package name (e.g., "CXX Core Compute Libraries")
  # description : String
  description
, # platforms : List System
  platforms
, # version : Version
  version
, # releaseAttrs : ReleaseAttrs
  releaseAttrs
, # releaseFeaturesAttrs : ReleaseFeaturesAttrs
  releaseFeaturesAttrs
,
}:
let
  # Useful imports
  inherit (lib.lists) optionals;
  inherit (lib.meta) getExe;
  inherit (lib.strings) optionalString;
in
backendStdenv.mkDerivation {
  # NOTE: Even though there's no actual buildPhase going on here, the derivations of the
  # redistributables are sensitive to the compiler flags provided to stdenv. The patchelf package
  # is sensitive to the compiler flags provided to stdenv, and we depend on it. As such, we are
  # also sensitive to the compiler flags provided to stdenv.
  inherit pname version;
  strictDeps = true;

  outputs = with releaseFeaturesAttrs;
    [ "out" ]
    ++ optionals hasBin [ "bin" ]
    ++ optionals hasLib [ "lib" ]
    ++ optionals hasStatic [ "static" ]
    ++ optionals hasDev [ "dev" ]
    ++ optionals hasDoc [ "doc" ]
    ++ optionals hasSample [ "sample" ];

  src = fetchurl {
    url = "https://developer.download.nvidia.com/compute/cuda/redist/${releaseAttrs.relative_path}";
    inherit (releaseAttrs) sha256;
  };

  # We do need some other phases, like configurePhase, so the multiple-output setup hook works.
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    # This hook will make sure libcuda can be found
    # in typically /lib/opengl-driver by adding that
    # directory to the rpath of all ELF binaries.
    # Check e.g. with `patchelf --print-rpath path/to/my/binary
    autoAddOpenGLRunpathHook
    markForCudatoolkitRootHook
  ];

  buildInputs = [
    # autoPatchelfHook will search for a libstdc++ and we're giving it
    # one that is compatible with the rest of nixpkgs, even when
    # nvcc forces us to use an older gcc
    # NB: We don't actually know if this is the right thing to do
    stdenv.cc.cc.lib
  ];

  # Picked up by autoPatchelf
  # Needed e.g. for libnvrtc to locate (dlopen) libnvrtc-builtins
  appendRunpaths = [
    "$ORIGIN"
  ];

  installPhase = with releaseFeaturesAttrs;
    # Pre-install hook
    ''
      runHook preInstall
    ''
    # doc and dev have special output handling. Other outputs need to be moved to their own
    # output.
    # Note that moveToOutput operates on all outputs:
    # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L105-L107
    + ''
      mkdir -p "$out"
      rm LICENSE
      mv * "$out"
    ''
    # Handle bin, which defaults to out
    + optionalString hasBin ''
      moveToOutput "bin" "$bin"
    ''
    # Handle lib, which defaults to out
    + optionalString hasLib ''
      moveToOutput "lib" "$lib"
    ''
    # Handle static libs, which isn't handled by the setup hook
    + optionalString hasStatic ''
      moveToOutput "**/*.a" "$static"
    ''
    # Handle samples, which isn't handled by the setup hook
    + optionalString hasSample ''
      moveToOutput "samples" "$sample"
    ''
    # Post-install hook
    + ''
      runHook postInstall
    '';

  # The out output leverages the same functionality which backs the `symlinkJoin` function in
  # Nixpkgs:
  # https://github.com/NixOS/nixpkgs/blob/d8b2a92df48f9b08d68b0132ce7adfbdbc1fbfac/pkgs/build-support/trivial-builders/default.nix#L510
  #
  # That should allow us to emulate "fat" default outputs without having to actually create them.
  #
  # It is important that this run after the autoPatchelfHook, otherwise the symlinks in out will reference libraries in lib, creating a circular dependency.
  postPhases = [ "postPatchelf" ];
  # For each output, create a symlink to it in the out output.
  # NOTE: We must recreate the out output here, because the setup hook will have deleted it
  # if it was empty.
  # NOTE: Do not use optionalString based on whether `outputs` contains only `out` -- phases
  # which are empty strings are skipped/unset and result in errors of the form "command not
  # found: <customPhaseName>".
  postPatchelf = ''
    mkdir -p "$out"
    for output in $outputs; do
      if [ "$output" = "out" ]; then
        continue
      fi
      ${getExe lndir} "''${!output}" "$out"
    done
  '';

  # Make the CUDA-patched stdenv available
  passthru.stdenv = backendStdenv;

  # Setting propagatedBuildInputs to false will prevent outputs known to the multiple-outputs
  # from depending on `out` by default.
  # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L196
  # Indeed, we want to do the opposite -- fat "out" outputs that contain all the other outputs.
  propagatedBuildOutputs = false;

  # By default, if the dev output exists it just uses that.
  # However, because we disabled propagatedBuildOutputs, dev doesn't contain libraries or
  # anything of the sort. To remedy this, we set outputSpecified to true, and use
  # outputsToInstall, which tells Nix which outputs to use when the package name is used
  # unqualified (that is, without an explicit output).
  outputSpecified = true;

  meta = {
    inherit description platforms;
    license = lib.licenses.unfree;
    maintainers = lib.teams.cuda.members;
    # Force the use of the default, fat output by default (even though `dev` exists, which
    # causes Nix to prefer that output over the others if outputSpecified isn't set).
    outputsToInstall = [ "out" ];
  };
}
