{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, numpy
, six
, withTreeVisualization ? false
, lxml
, withXmlSupport ? false
, pyqt4
, pyqt5
}:

buildPythonPackage rec {
  pname = "ete3";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4fc987b8c529889d6608fab1101f1455cb5cbd42722788de6aea9c7d0a8e59e9";
  };


  doCheck = false; # Tests are (i) not 3.x compatible, (ii) broken under 2.7
  pythonImportsCheck = [ "ete3" ];

  propagatedBuildInputs = [ six numpy ]
    ++ lib.optional withTreeVisualization (if isPy3k then pyqt5 else pyqt4)
    ++ lib.optional withXmlSupport lxml;

  meta = with lib; {
    description = "A Python framework for the analysis and visualization of trees";
    homepage = "http://etetoolkit.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ delehef ];
  };
}
