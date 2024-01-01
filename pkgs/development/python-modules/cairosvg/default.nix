{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, cairocffi
, cssselect2
, defusedxml
, pillow
, tinycss2
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.7.1";
  disabled = !isPy3k;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QyUx1yNHKRuanr+2d3AmtgdWP9hxnEbudC2wrvcnG6A=";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 setuptools];

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
    license = licenses.lgpl3Plus;
    description = "SVG converter based on Cairo";
    maintainers = with maintainers; [ dansbandit ];
  };
}
