{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  setuptools,
  lxml,
  pymupdf,
  pysrt,
  translatehtml,
}:

let
  inherit (stdenv.hostPlatform) isLinux isAarch64;
  isAarch64Linux = isLinux && isAarch64;
in
buildPythonPackage (finalAttrs: {
  pname = "argos-translate-files";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "argos-translate-files";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6AxVBiK0g6ajstyCQZ9ExF9MRYSLd4Frw03N7c9bvuI=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "beautifulsoup4" ];

  # LibreTranslate has forked argos-translate [1] to fix some bugs and
  # make stanza optional, but it's unclear what the future of this fork
  # is.
  #
  # We'll stay on upstream argostranslate for now.
  #
  # [1]: https://github.com/Libretranslate/argos-translate/
  pythonRemoveDeps = [ "argos-translate-lt" ];

  dependencies = [
    lxml
    pymupdf
    pysrt
    translatehtml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # pythonImportsCheck needs a home dir for argostranslatefiles
    writableTmpDirAsHomeHook
  ];

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
  # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
  pythonImportsCheck = lib.optional (!isAarch64Linux) "argostranslatefiles";
  doCheck = !isAarch64Linux;

  meta = {
    description = "Translate files using Argos Translate";
    homepage = "https://www.argosopentech.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})
