{
  autoPatchelfHook,
  buildPythonPackage,
  fetchurl,
  lib,
  python,
  pythonAtLeast,
  stdenv,

  # native dependencies
  openvino-native,

  # dependencies
  backports-strenum,
  flatbuffers,
  numpy,
  protobuf,
  tqdm,
  typing-extensions,

  # optional-dependencies
  lark,
  ml-dtypes,
}:

let
  release = builtins.fromJSON (builtins.readFile ./release.json);
  platforms = release.src;
  platform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "ai-edge-litert: unsupported platform (${stdenv.hostPlatform.system})");
  pythonMajorMinor = lib.versions.majorMinor python.version;
  source =
    platform.${pythonMajorMinor}
      or (throw "ai-edge-litert: unsupported python version (${pythonMajorMinor})");
in

buildPythonPackage {
  pname = "ai-edge-litert";
  version = release.version;
  format = "wheel";

  src = fetchurl {
    inherit (source)
      url
      hash
      ;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ openvino-native ];

  dependencies = [
    backports-strenum
    flatbuffers
    numpy
    protobuf
    tqdm
    typing-extensions
  ];

  optional-dependencies = {
    model-utils = [
      lark
      ml-dtypes
      # TODO :xdsl
    ];
    # TODO: npu-intel
    # TODO: npu-sdk
  };

  autoPatchelfIgnoreMissingDeps = [
    # Qualcomm Neural Network SDK
    # https://www.qualcomm.com/developer/software/qualcomm-ai-engine-direct-sdk
    "libQnnHtp.so"
    "libQnnIr.so"
    "libQnnSaver.so"
    "libQnnSystem.so"
  ];

  pythonRemoveDeps = lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/google-ai-edge/LiteRT/pull/5298
    "backports.strenum"
  ];

  pythonImportsCheck = [
    "ai_edge_litert"
    "ai_edge_litert.interpreter"
  ];

  passthru.updateScript = ./update.py;

  meta = {
    changelog = "https://github.com/google-ai-edge/LiteRT/releases/tag/v${release.version}";
    description = "LiteRT is for mobile and embedded devices";
    downloadPage = "https://github.com/google-ai-edge/LiteRT";
    homepage = "https://www.tensorflow.org/lite/";
    license = lib.licenses.asl20;
    platforms = lib.attrNames platforms;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ hexa ];
    badPlatforms = [
      # elftools.common.exceptions.ELFError: Magic number does not match
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
