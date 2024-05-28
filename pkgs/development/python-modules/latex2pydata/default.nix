{ lib
, fetchPypi
, buildPythonPackage
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "latex2pydata";
  version = "0.2.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lFYGBFox7fv/vlfqZN3xsh9UIRCQ+C5Cizq9j4RTcJ0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/gpoore/latex2pydata";
    description = "Send data from LaTeX to Python using Python literal format";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
