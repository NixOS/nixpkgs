{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2022.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HnYOL+aoFjvAs9mhnE+ENCr6Cir/6/qoSwG5eKAuyqc=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s pytz/tests
  '';

  pythonImportsCheck = [ "pytz" ];

  meta = with lib; {
    description = "World timezone definitions, modern and historical";
    homepage = "https://pythonhosted.org/pytz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
