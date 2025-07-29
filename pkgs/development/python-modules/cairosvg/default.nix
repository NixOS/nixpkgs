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
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "CairoSVG";
    tag = version;
    hash = "sha256-KWUZA8pcHMnDEkAYZt3zDzPNynhGBuLZuagNPfHF8EA=";
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
