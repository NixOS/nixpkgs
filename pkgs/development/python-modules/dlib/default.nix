{ buildPythonPackage, lib, dlib, python, pytest, more-itertools,
  avxSupport ? builtins.elem (stdenv.hostPlatform.platform.gcc.arch or "default") [ "sandybridge" "ivybridge" "haswell" "broadwell" "skylake" "skylake-avx512" "btver2" "bdver1" "bdver2" "bdver3" "bdver4" "znver1"]
}:

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

  enableParallelBuilding = true;
  dontUseCmakeConfigure = true;
}
