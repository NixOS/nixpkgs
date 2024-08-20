{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  six,
  withTreeVisualization ? false,
  lxml,
  withXmlSupport ? false,
  pyqt5,
}:

buildPythonPackage rec {
  pname = "ete3";
  version = "3.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BqO3+o7ZAYewdqjbvlsbYqzulCAdPG6CL1X0SWAe9vI=";
  };

  doCheck = false; # Tests are (i) not 3.x compatible, (ii) broken under 2.7
  pythonImportsCheck = [ "ete3" ];

  propagatedBuildInputs = [
    six
    numpy
  ] ++ lib.optional withTreeVisualization pyqt5 ++ lib.optional withXmlSupport lxml;

  meta = with lib; {
    description = "Python framework for the analysis and visualization of trees";
    mainProgram = "ete3";
    homepage = "http://etetoolkit.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ delehef ];
  };
}
