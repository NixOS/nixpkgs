{ buildPythonPackage
, fetchFromGitHub
, lib
, stdenv
, darwin
, cmake
, ninja
, poetry-core
, scikit-build
, setuptools
, typing-extensions
}:

let
  inherit (stdenv) isDarwin;
  osSpecific = with darwin.apple_sdk.frameworks; if isDarwin then [ Accelerate CoreGraphics CoreVideo ] else [ ];
  llama-cpp-pin = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "2e6cd4b02549e343bef3768e6b946f999c82e823";
    hash = "sha256-VzY3e/EJ+LLx55H0wkIVoHfZ0zAShf6Y9Q3fz4xQ0V8=";
  };
in
buildPythonPackage rec {
  pname = "llama-cpp-python";
  version = "0.1.54";

  format = "pyproject";
  src = fetchFromGitHub {
    owner = "abetlen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8YIMbJIMwWJWkXjnjcgR5kvSq4uBd6E/IA2xRm+W5dM=";
  };

  preConfigure = ''
    cp -r ${llama-cpp-pin}/. ./vendor/llama.cpp
    chmod -R +w ./vendor/llama.cpp
  '';
  preBuild = ''
    cd ..
  '';
  buildInputs = osSpecific;

  nativeBuildInputs = [
    cmake
    ninja
    poetry-core
    scikit-build
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  pythonImportsCheck = [ "llama_cpp" ];

  meta = with lib; {
    description = "A Python wrapper for llama.cpp";
    homepage = "https://github.com/abetlen/llama-cpp-python";
    license = licenses.mit;
    maintainers = [ ];
  };
}
