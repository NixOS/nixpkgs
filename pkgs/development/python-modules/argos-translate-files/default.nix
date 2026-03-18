{
  lib,
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

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    # pythonImportsCheck needs a home dir for argostranslatefiles
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "argostranslatefiles" ];

  meta = {
    description = "Translate files using Argos Translate";
    homepage = "https://www.argosopentech.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})
