{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "epaper-dithering";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "epaper-dithering";
    tag = "python-v${finalAttrs.version}";
    hash = "sha256-GWILjyzPg5mCDQ6jQw5o3v+gkbdxiHzSSVQkW3dC01I=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python";

  build-system = [ hatchling ];

  dependencies = [
    numpy
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "epaper_dithering" ];

  meta = {
    description = "Dithering algorithms for e-paper/e-ink displays";
    homepage = "https://github.com/OpenDisplay/epaper-dithering";
    changelog = "https://github.com/OpenDisplay/epaper-dithering/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
