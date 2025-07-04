{
  lib,
  lammps,
  stdenv,
  buildPythonPackage,
}:

let
  LAMMPS_SHARED_LIB = "${lib.getLib lammps}/lib/liblammps${stdenv.hostPlatform.extensions.library}";
in
buildPythonPackage {
  format = "setuptools";
  inherit (lammps) pname version src;

  env = {
    # Needed for tests
    inherit LAMMPS_SHARED_LIB;
  };
  # Don't perform checks if GPU is enabled - because libcuda.so cannot be opened in the sandbox
  doCheck = if lammps.passthru.packages ? GPU then !lammps.passthru.packages.GPU else true;
  preConfigure = ''
    cd python
    # Upstream assumes that the shared library is located in the same directory
    # as the core.py file. We want to separate the shared library (built by
    # cmake) and the Python library, so we perform this substitution:
    substituteInPlace lammps/core.py \
      --replace-fail \
        "from inspect import getsourcefile" \
        "getsourcefile = lambda f: \"${LAMMPS_SHARED_LIB}\""
  '';

  pythonImportsCheck = [
    "lammps"
    "lammps.pylammps"
  ];

  # We could potentially run other examples, but some of them are so old that
  # they don't run with nowadays' LAMMPS. This one is simple enough and recent
  # enough and it works.
  checkPhase = ''
    python examples/mc.py examples/in.mc
  '';

  meta = {
    description = "Python Bindings for LAMMPS";
    homepage = "https://docs.lammps.org/Python_head.html";
    inherit (lammps.meta) license;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
