{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fonttools,
  hatch-vcs,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "fontpens";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotools";
    repo = "fontpens";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K768vbhacnuSRlmC3QG+7p+y8QiBtvqETvCYOuO1IxM=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ fonttools ];

  # can't run normal tests due to circular dependency with fontParts
  doCheck = false;
  pythonImportsCheck = [
    "fontPens"
  ]
  ++ (map (s: "fontPens." + s) [
    "angledMarginPen"
    "digestPointPen"
    "flattenPen"
    "guessSmoothPointPen"
    "marginPen"
    "penTools"
    "printPen"
    "printPointPen"
    "recordingPointPen"
    "thresholdPen"
    "thresholdPointPen"
    "transformPointPen"
  ]);

  meta = {
    changelog = "https://github.com/robotools/fontPens/releases/tag/${finalAttrs.src.tag}";
    description = "Collection of classes implementing the pen protocol for manipulating glyphs";
    homepage = "https://github.com/robotools/fontPens";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
