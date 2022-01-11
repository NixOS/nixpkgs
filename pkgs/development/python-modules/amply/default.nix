{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, docutils
, pyparsing
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "amply";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb12dcb49d16b168c02be128a1527ecde50211e4bd94af76ff4e67707f5a2d38";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    docutils
    pyparsing
  ];
  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "amply" ];

  meta = with lib; {
    homepage = "https://github.com/willu47/amply";
    description = ''
      Allows you to load and manipulate AMPL/GLPK data as Python data structures
    '';
    maintainers = with maintainers; [ ris ];
    license = licenses.epl10;
  };
}
