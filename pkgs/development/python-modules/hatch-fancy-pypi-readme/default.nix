{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, build
, hatchling
}:

buildPythonPackage rec {
  pname = "hatch-fancy-pypi-readme";
  version = "22.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "hatch_fancy_pypi_readme";
    inherit version;
    hash = "sha256-3t8roLgaKXWrsd7ukxCy64XSI4D9oNUoaedgtUNapZY=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    hatchling
  ];

  checkInputs = [
    build
    pytestCheckHook
  ];

  # Requires network connection
  disabledTests = [
    "test_build"  # Requires internet
    "test_invalid_config"
  ];

  pythonImportsCheck = [
    "hatch_fancy_pypi_readme"
  ];

  meta = with lib; {
    description = "Fancy PyPI READMEs with Hatch";
    homepage = "https://github.com/hynek/hatch-fancy-pypi-readme";
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
