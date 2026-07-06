{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  afdko,
  cffsubr,
  defcon,
  dehinter,
  fonttools,
  ttfautohint-py,
  ufo2ft,
  ufolib2,
  ufo-extractor,
}:
buildPythonPackage (finalAttrs: {
  pname = "foundrytools";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ftCLI";
    repo = "FoundryTools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dmMu9FTr754ax6dSfz1cn/CgmMVbEECQgyZaW+66UrU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    afdko
    cffsubr
    defcon
    dehinter
    fonttools
    ttfautohint-py
    ufo-extractor
    ufo2ft
    ufolib2
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Library for working with fonts in Python";
    homepage = "https://github.com/ftCLI/FoundryTools";
    changelog = "https://github.com/ftCLI/FoundryTools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      qb114514
    ];
  };
})
