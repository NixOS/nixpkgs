{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  mypy-protobuf,

  # dependencies
  evaluate,
  joblib,
  ninja,
  numpy,
  onnx,
  onnxscript,
  onnxslim,
  pandas,
  plotly,
  protobuf,
  pydantic,
  rich,
  scipy,
  sentencepiece,
  tqdm,
  zstandard,
}:
buildPythonPackage (finalAttrs: {
  pname = "amd-quark";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amd";
    repo = "Quark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x0y3NFbXAF1SnlzQSkWKEWiz0qRPYHWvQ6oTizKpyQw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"protobuf-protoc-bin==31.1",' ""
    substituteInPlace setup.py \
      --replace-fail 'subprocess.check_output(["git", "rev-parse", "--short", "HEAD"])' 'b"nix"'
  '';

  env.QUARK_RELEASE = "1";

  build-system = [
    setuptools
    mypy-protobuf
  ];

  dependencies = [
    evaluate
    joblib
    ninja
    numpy
    onnx
    onnxscript
    onnxslim
    pandas
    plotly
    protobuf
    pydantic
    rich
    scipy
    sentencepiece
    tqdm
    zstandard
  ];

  pythonRelaxDeps = true;

  pythonImportsCheck = [ "quark" ];

  # Most of the tests require gpu and some other unspecified dependencies
  doCheck = false;

  meta = {
    description = "AMD Quark Model Optimizer";
    homepage = "https://github.com/amd/Quark";
    changelog = "https://github.com/amd/Quark/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lach ];
  };
})
