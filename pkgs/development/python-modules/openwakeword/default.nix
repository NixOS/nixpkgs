{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchurl,
  setuptools,
  numpy,
  onnxruntime,
  scipy,
  tqdm,
  requests,
  scikit-learn,
  python,
}:

let
  base = "https://github.com/dscripka/openWakeWord/releases/download/v0.5.1";

  fetchModel =
    name: hash:
    fetchurl {
      url = "${base}/${name}";
      inherit hash;
    };

  embeddingTflite = fetchModel "embedding_model.tflite" "sha256-wK6iHrhKTOkKCMhw2kG3pxc7RSaeajIHxx1nxA86Wdg=";
  embeddingOnnx = fetchModel "embedding_model.onnx" "sha256-cNFkKQwdCV0dTuFJvF4AVDJQpzFrWfMdBWz/e9MHXB8=";
  melspectrogramTflite = fetchModel "melspectrogram.tflite" "sha256-lvoK3MtujPlcsURlQJoaKJjuSpaoW7ntPH6w5ovxY+g=";
  melspectrogramOnnx = fetchModel "melspectrogram.onnx" "sha256-uisOD4t7h1NposicsTNg/1O6xDbyiVzO2fR5+mXrF28=";
  sileroVad = fetchModel "silero_vad.onnx" "sha256-o16/Uv085fFGmyo2FY26dhvEe5c+ozgrMYbKFbH1ryg=";
in
buildPythonPackage (finalAttrs: {
  pname = "openwakeword";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NoWNkPEYPjB0hVl6kSpOPDOEsU6pkj+D/q/658FWVWU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    onnxruntime
    scipy
    tqdm
    requests
    scikit-learn
  ];

  # tflite-runtime has no Python 3.13 wheels and isn't in nixpkgs.
  # openwakeword falls back to onnxruntime when tflite-runtime is absent
  pythonRemoveDeps = [ "tflite-runtime" ];

  postInstall = ''
    dest="$out/${python.sitePackages}/openwakeword/resources/models"
    install -Dm644 ${embeddingTflite}      "$dest/embedding_model.tflite"
    install -Dm644 ${embeddingOnnx}        "$dest/embedding_model.onnx"
    install -Dm644 ${melspectrogramTflite} "$dest/melspectrogram.tflite"
    install -Dm644 ${melspectrogramOnnx}   "$dest/melspectrogram.onnx"
    install -Dm644 ${sileroVad}            "$dest/silero_vad.onnx"
  '';

  pythonImportsCheck = [
    "openwakeword"
    "openwakeword.model"
  ];

  # The upstream test suite depends on pytest-flake8, pytest-cov, and several
  # other dev-only packages not included in this derivation. Additionally,
  # functional tests require audio hardware or real microphone input and
  # pre-downloaded model files, making them unsuitable for a sandboxed Nix
  # build environment.
  doCheck = false;

  meta = {
    description = "An open-source audio wake word detection library";
    homepage = "https://github.com/dscripka/openWakeWord";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ZachDavies ];
  };
})
