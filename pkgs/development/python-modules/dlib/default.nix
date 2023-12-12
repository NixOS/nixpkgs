{ lib, stdenv, buildPythonPackage, dlib, python, pytest, more-itertools }:

buildPythonPackage ({
  inherit (dlib) pname version src nativeBuildInputs buildInputs cmakeFlags meta;

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

  dontUseCmakeConfigure = true;

  # Pass CMake flags through to the build script
  preConfigure = ''
    setupPyBuildFlags="$setupPyBuildFlags $(sed 's/-D\(\S*\)/--set \1/g' <<< "$cmakeFlags")"
  '';

  doCheck = !(
    # The tests attempt to use CUDA on the build platform.
    dlib.cudaSupport

      # although AVX can be enabled, we never test with it. Some Hydra machines
      # fail because of this, however their build results are probably used on hardware
      # with AVX support.
      || dlib.avxSupport
  );

  checkPhase = ''
    ${python.interpreter} nix_run_setup test
  '';
} // lib.optionalAttrs dlib.cudaSupport { stdenv = dlib.cudaPackages.backendStdenv; })
