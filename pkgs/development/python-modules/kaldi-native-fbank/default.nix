{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  pybind11,
  kissfft,
}:
buildPythonPackage (finalAttrs: {
  pname = "kaldi-native-fbank";
  version = "1.22.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csukuangfj";
    repo = "kaldi-native-fbank";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wu4wM52T6NoQ1t5/iAyPtkEGnZki5P0jx0eYMFZMb5o=";
  };

  build-system = [
    cmake
    setuptools
  ];

  buildInputs = [ pybind11 ];

  dontUseCmakeConfigure = true;

  env.KALDI_NATIVE_FBANK_CMAKE_ARGS = lib.concatStringsSep " " [
    "-DFETCHCONTENT_SOURCE_DIR_KISSFFT=${kissfft.src}"
    "-DFETCHCONTENT_SOURCE_DIR_PYBIND11=${pybind11.src}"
    "-DKALDI_NATIVE_FBANK_BUILD_TESTS=OFF"
    "-DKALDI_NATIVE_FBANK_BUILD_PYTHON=ON"
  ];

  pythonImportsCheck = [ "kaldi_native_fbank" ];

  meta = {
    description = "Kaldi-compatible online fbank extractor without external dependencies";
    homepage = "https://github.com/csukuangfj/kaldi-native-fbank";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lach ];
  };
})
