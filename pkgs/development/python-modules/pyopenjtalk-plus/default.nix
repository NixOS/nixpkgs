{
  lib,
  replaceVars,
  buildPythonPackage,
  fetchFromGitHub,
  fetchgit,
  cmake,
  cython,
  numpy,
  setuptools,
  pydantic,
  sudachipy,
  sudachidict-core,
  typing-extensions,
  pytestCheckHook,
  onnxruntime,
  tokenizers,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyopenjtalk-plus";
  version = "0.4.1.post9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsukumijima";
    repo = "pyopenjtalk-plus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o/NC8/XBGegpNaVToFmnQRID1XrsEBAuZjjgLxhniyU=";
    fetchSubmodules = true;
  };

  # logic to download these if not present is built in, but won't work in the sandbox, and the files are required for tests
  tsqyomiModelDir = fetchgit {
    url = "https://huggingface.co/tsukumijima/tsqyomi-models";
    rev = "680596dd2ad2bad59ee5db3741e197cfce79f9b4";
    fetchLFS = true;
    rootDir = "v4";
    hash = "sha256-pOUnXml1QlpTthC48DBPb2iziOmAu4/9gb0trGItNTE=";
  };

  patches = [
    (replaceVars ./tsqyomi_model_dir.patch {
      model_dir = finalAttrs.tsqyomiModelDir;
    })
  ];

  postPatch = ''
    grep -q ${finalAttrs.tsqyomiModelDir.rev} pyopenjtalk/tsqyomi/model.py || (echo "wrong model rev in nix package" && exit 1)
  '';

  build-system = [
    cmake
    cython
    numpy
    setuptools
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    numpy
    pydantic
    sudachipy
    sudachidict-core
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    onnxruntime
    tokenizers
  ];

  preCheck = ''
    # the built extension modules are only present in $out
    # so we make sure to resolve pyopenjtalk from $out
    mv pyopenjtalk _pyopenjtalk
    # not all files in the dictionary dir are installed into $out
    # however, the tests still need them, so we specify the original dictionary dir
    export OPEN_JTALK_DICT_DIR=_pyopenjtalk/dictionary
  '';

  pythonImportsCheck = [ "pyopenjtalk" ];

  meta = {
    description = "Python wrapper for OpenJTalk with additional improvements";
    homepage = "https://github.com/tsukumijima/pyopenjtalk-plus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jcaesar ];
  };
})
