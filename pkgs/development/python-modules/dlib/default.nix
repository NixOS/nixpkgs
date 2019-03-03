{ buildPythonPackage, dlib, python, pytest, avxSupport ? true }:

buildPythonPackage {
  inherit (dlib) name src nativeBuildInputs buildInputs meta;

  # although AVX can be enabled, we never test with it. Some Hydra machines
  # fail because of this, however their build results are probably used on hardware
  # with AVX support.
  checkPhase = ''
    ${python.interpreter} nix_run_setup test --no USE_AVX_INSTRUCTIONS
  '';

  setupPyBuildFlags = [ "--${if avxSupport then "yes" else "no"} USE_AVX_INSTRUCTIONS" ];

  patches = [ ./build-cores.patch ];

  checkInputs = [ pytest ];
}
