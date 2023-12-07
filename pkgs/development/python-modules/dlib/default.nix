{ stdenv, buildPythonPackage, dlib, python, pytest, more-itertools
, sse4Support ? stdenv.hostPlatform.sse4_1Support
, avxSupport ? stdenv.hostPlatform.avxSupport
}:

buildPythonPackage {
  inherit (dlib) pname version src nativeBuildInputs buildInputs meta;

  format = "setuptools";

  patches = [
    ./build-cores.patch
  ];

  nativeCheckInputs = [ pytest more-itertools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "more-itertools<6.0.0" "more-itertools" \
      --replace "pytest==3.8" "pytest"
  '';

  # although AVX can be enabled, we never test with it. Some Hydra machines
  # fail because of this, however their build results are probably used on hardware
  # with AVX support.
  checkPhase = ''
    ${python.interpreter} nix_run_setup test --no USE_AVX_INSTRUCTIONS
  '';

  setupPyBuildFlags = [
    "--set USE_SSE4_INSTRUCTIONS=${if sse4Support then "yes" else "no"}"
    "--set USE_AVX_INSTRUCTIONS=${if avxSupport then "yes" else "no"}"
  ];

  dontUseCmakeConfigure = true;
}
