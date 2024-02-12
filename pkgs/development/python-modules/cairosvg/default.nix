{ lib
, buildPythonPackage
, cairocffi
, cssselect2
, defusedxml
, fetchPypi
, pillow
, pytestCheckHook
, setuptools
, tinycss2
}:

buildPythonPackage rec {
  pname = "cairosvg";
  version = "2.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "CairoSVG";
    inherit version;
    hash = "sha256-rE3HwdOLOhVxfbJjOjo4MBLgvmZMcnyRFjfmr2pJKTw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  propagatedNativeBuildInputs = [ cairocffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" "" \
      --replace "pytest-flake8" "" \
      --replace "pytest-isort" "" \
      --replace "pytest-cov" "" \
      --replace "--flake8" "" \
      --replace "--isort" ""
  '';

  pytestFlagsArray = [
    "cairosvg/test_api.py"
  ];

  pythonImportsCheck = [ "cairosvg" ];

  meta = with lib; {
    homepage = "https://cairosvg.org";
    changelog = "https://github.com/Kozea/CairoSVG/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    description = "SVG converter based on Cairo";
    maintainers = with maintainers; [ ];
  };
}
