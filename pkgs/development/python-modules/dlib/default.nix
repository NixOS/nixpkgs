{ buildPythonPackage, dlib, python, pytest, more-itertools, avxSupport ? true, lib }:

buildPythonPackage {
  inherit (dlib) name src nativeBuildInputs buildInputs meta;

  # although AVX can be enabled, we never test with it. Some Hydra machines
  # fail because of this, however their build results are probably used on hardware
  # with AVX support.
  checkPhase = ''
    ${python.interpreter} nix_run_setup test --no USE_AVX_INSTRUCTIONS
  '';

  setupPyBuildFlags = lib.optional avxSupport "--no USE_AVX_INSTRUCTIONS";

  patches = [ ./build-cores.patch ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "more-itertools<6.0.0" "more-itertools" \
      --replace "pytest==3.8" "pytest"
  '';

  checkInputs = [ pytest more-itertools ];
}
