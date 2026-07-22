{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  cmake,
  ninja,
  scikit-build-core,

  # buildInputs
  ggml,

  # dependencies
  numpy,
  typing-extensions,

  # optional-dependencies
  accelerate,
  sentencepiece,
  torch,
  torchaudio,
  torchvision,
  transformers,
  cairosvg,
  mkdocs,
  mkdocs-material,
  mkdocstrings,
  pillow,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ggml-python";
  version = "0.0.44";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abetlen";
    repo = "ggml-python";
    tag = "v${finalAttrs.version}";
    # ggml-python expects an older version of ggml than pkgs.ggml's
    fetchSubmodules = true;
    hash = "sha256-Pjc91nKBAdmEg8TmirWdD1AcKlY+BCDAoHzL6mTE2SM=";
  };

  build-system = [
    cmake
    ninja
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    ggml
  ];

  dependencies = [
    numpy
    typing-extensions
  ];

  optional-dependencies = {
    convert = [
      accelerate
      numpy
      sentencepiece
      torch
      torchaudio
      torchvision
      transformers
    ];
    docs = [
      cairosvg
      mkdocs
      mkdocs-material
      mkdocstrings
      pillow
    ];
  };

  pythonImportsCheck = [ "ggml" ];

  preCheck = ''
    rm -rf ggml
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Python bindings for ggml";
    homepage = "https://github.com/abetlen/ggml-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
