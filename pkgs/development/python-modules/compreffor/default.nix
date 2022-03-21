{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, fonttools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "compreffor";
  version = "0.5.1.post1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "Zqia+yP4Dp5VNGeMwv+j04aNm9oVmZ2juehbfEzDfOQ=";
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
