{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "kanjize";
  version = "1.6.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nagataaaas";
    repo = "kanjize";
    tag = finalAttrs.version;
    hash = "sha256-eR4rtGpwzZ8VALiaybr6fdUok6DkvZc+Q1AONIfr4s4=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "kanjize"
  ];

  meta = {
    description = "Easy converter between Kanji-Number and Integer";
    homepage = "https://pypi.org/project/kanjize/";
    changelog = "https://github.com/nagataaaas/Kanjize/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ colepearson27 ];
  };
})
