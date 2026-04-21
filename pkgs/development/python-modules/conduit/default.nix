{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,

  # build-system
  cmake,
  ninja,
  setuptools,

  # dependencies
  numpy,
  pip,

  mpiSupport ? false,
}:
let
  conduit = pkgs.conduit.override { inherit mpiSupport; };
in
buildPythonPackage {
  inherit (conduit)
    pname
    version
    src
    buildInputs
    ;
  pyproject = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "cmake<=3.30.0" \
        "cmake"
  '';

  # Needed for cmake to find openmpi
  strictDeps = false;

  dontUseCmakeConfigure = true;

  env.ENABLE_MPI = mpiSupport;

  build-system = [
    cmake
    ninja
    setuptools
  ];

  dependencies = [
    numpy
    pip
  ];

  pythonImportsCheck = [ "conduit" ];

  # No python tests
  doCheck = false;

  meta = {
    description = "Python bindings for the conduit library";
    inherit (conduit.meta)
      homepage
      changelog
      license
      platforms
      ;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    # Cross-compilation is broken
    broken = stdenv.hostPlatform != stdenv.buildPlatform;
  };
}
