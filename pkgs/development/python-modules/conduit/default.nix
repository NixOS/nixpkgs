{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,

  # build-system
  cmake,
  ninja,
  pip,
  setuptools,

  # nativeBuildInputs
  openmpi,

  # dependencies
  numpy,

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
    # nativeBuildInputs
    buildInputs
    ;
  pyproject = true;
  __structuredAttrs = true;

  postPatch = (conduit.postPatch or "") + ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "cmake<=3.30.0" \
        "cmake"
  '';

  env.ENABLE_MPI = mpiSupport;

  build-system = [
    cmake
    ninja
    pip
    setuptools
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = conduit.nativeBuildInputs ++ [
    # openmpi needs to be in nativeBuildInputs, otherwise cmake can't find it
    openmpi
  ];

  dependencies = [
    numpy
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
