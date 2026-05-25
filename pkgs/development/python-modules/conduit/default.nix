{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,
  setuptools,
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
    nativeBuildInputs
    buildInputs
    ;
  pyproject = true;

  # Needed for cmake to find openmpi
  strictDeps = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "'-j2'" \
        "f'-j{os.environ.get(\"NIX_BUILD_CORES\")}'"
  '';

  dontUseCmakeConfigure = true;

  env.ENABLE_MPI = mpiSupport;

  build-system = [
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
