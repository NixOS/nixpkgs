{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook

, click
, commentjson
, kicad
, lark
, markdown2
, pcbnew-transition
, pybars3
, shapely
, solidpython
, versioneer
, wcwidth
, wxPython_4_2
}:

buildPythonPackage rec {
  pname = "kikit";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "yaqwsx";
    repo = "KiKit";
    rev = "v${version}";
    hash = "sha256-kDTPk/R3eZtm4DjoUV4tSQzjGQ9k8MKQedX4oUXYzeo=";
  };

  buildInputs = [
    versioneer
  ];

  checkInputs = [ wxPython_4_2 ];

  propagatedBuildInputs = [
    kicad
    pcbnew-transition
    shapely
    click
    markdown2
    pybars3
    lark
    solidpython
    commentjson
    wcwidth
  ];

  pythonImportsCheck = [ "kikit" ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace test/units/test_sexpr.py \
      --replace 'SOURCE = "../resources/conn.kicad_pcb"' "SOURCE = \"$src/test/resources/conn.kicad_pcb\""
  '';

  meta = with lib; {
    description = "Automation for KiCAD";
    homepage = "https://github.com/yaqwsx/KiKit";
    license = licenses.mit;
    maintainers = with maintainers; [ tmarkus ];
  };
}
