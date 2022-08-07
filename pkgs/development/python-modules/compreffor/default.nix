{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, fonttools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "compreffor";
  version = "0.5.2";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rsC0HJCl3IGqEqUqfCwRRNwzjtfGDlxcCkeOU3On22Q=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fonttools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Tests cannot seem to open the cpython module.
  doCheck = false;

  pythonImportsCheck = [
    "compreffor"
  ];

  meta = with lib; {
    description = "CFF table subroutinizer for FontTools";
    homepage = "https://github.com/googlefonts/compreffor";
    license = licenses.asl20;
    maintainers = with maintainers; [ jtojnar ];
  };
}
