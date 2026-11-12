{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cairocffi,
  cssselect2,
  defusedxml,
  pillow,
  tinycss2,

  # testing
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cairosvg";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "CairoSVG";
    tag = finalAttrs.version;
    hash = "sha256-yIUuhBmq15xwHznEq8l5z8QSkhQQc3GjTbJw5L2ZX+I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cairocffi
    cssselect2
    defusedxml
    pillow
    tinycss2
  ];

  nativeBuildInputs = [ cairocffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "cairosvg/test_api.py" ];

  pythonImportsCheck = [ "cairosvg" ];

  meta = {
    homepage = "https://cairosvg.org";
    changelog = "https://github.com/Kozea/CairoSVG/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    description = "SVG converter based on Cairo";
    mainProgram = "cairosvg";
    maintainers = [ lib.maintainers.sarahec ];
  };
})
