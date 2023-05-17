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
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rXF7SQtrcFWQn6oZXoKkQytwb4+VhUBQFy9Ckx5HhCY=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    docutils
    pyparsing
  ];
  nativeCheckInputs = [ pytestCheckHook ];

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
