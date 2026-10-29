{
  buildPythonPackage,
  cmake,
  dlib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage.override { inherit (dlib) stdenv; } {
  inherit (dlib)
    pname
    version
    src
    nativeBuildInputs
    buildInputs
    cmakeFlags
    passthru
    meta
    ;

  patches = [ ./build-cores.patch ];

  pyproject = true;
  build-system = [
    cmake
    setuptools
  ];

  # Pass CMake flags through to the build script
  preConfigure = ''
    for flag in $cmakeFlags; do
      if [[ "$flag" == -D* ]]; then
        setupPyBuildFlags+=" --set ''${flag#-D}"
      fi
    done
  '';

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck =
    !(
      # The tests attempt to use CUDA on the build platform.
      # https://github.com/NixOS/nixpkgs/issues/225912
      dlib.cudaSupport

      # although AVX can be enabled, we never test with it. Some Hydra machines
      # fail because of this, however their build results are probably used on hardware
      # with AVX support.
      || dlib.avxSupport
    );
}
