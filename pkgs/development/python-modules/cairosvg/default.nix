{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy3k
, cairocffi
, cssselect2
, defusedxml
, pillow
, tinycss2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.5.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sLmSnPXboAUXjXRqgDb88AJVUPSYylTbYYczIjhHg7w=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-27586.patch";
      url = "https://github.com/Kozea/CairoSVG/commit/12d31c653c0254fa9d9853f66b04ea46e7397255.patch";
      hash = "sha256-6ElTepPjEmhbv59jkzTnw+qhY7JlqS/lToIzZtfkh08=";
    })
  ];

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  propagatedNativeBuildInputs = [ cairocffi ];

  checkInputs = [ pytestCheckHook ];

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
