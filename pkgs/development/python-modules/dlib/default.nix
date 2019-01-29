{ buildPythonPackage, dlib, python, pytest }:

buildPythonPackage {
  inherit (dlib) name src nativeBuildInputs buildInputs meta;

  checkPhase = ''
    ${python.interpreter} nix_run_setup test --no USE_AVX_INSTRUCTIONS
  '';

  patches = [ ./build-cores.patch ];

  checkInputs = [ pytest ];
}
