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

buildPythonPackage rec {
  pname = "cairosvg";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "CairoSVG";
    tag = version;
    hash = "sha256-WtMFOYaN/cRrL1Q4ma/UkR3kNFObNhp0Gm7i9NQAqz8=";
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
    changelog = "https://github.com/Kozea/CairoSVG/releases/tag/${version}";
    license = lib.licenses.lgpl3Plus;
    description = "SVG converter based on Cairo";
    mainProgram = "cairosvg";
    maintainers = [ lib.maintainers.sarahec ];
  };
}
