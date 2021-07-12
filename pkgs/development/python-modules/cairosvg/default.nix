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
, pytest-runner
, pytest-flake8
, pytest-isort
}:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.5.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sLmSnPXboAUXjXRqgDb88AJVUPSYylTbYYczIjhHg7w=";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytestCheckHook pytest-flake8 pytest-isort ];

  pytestFlagsArray = [
    "cairosvg/test_api.py"
  ];

  pythonImportsCheck = [ "cairosvg" ];

  meta = with lib; {
    homepage = "https://cairosvg.org";
    license = licenses.lgpl3Plus;
    description = "SVG converter based on Cairo";
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
