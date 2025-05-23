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
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "CairoSVG";
    rev = version;
    hash = "sha256-uam53zT2V7aR8daVNOWlZZiexIZPotJxLO2Jg2JQewQ=";
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

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "console-scripts" "console_scripts"
  '';

  pytestFlagsArray = [ "cairosvg/test_api.py" ];

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
