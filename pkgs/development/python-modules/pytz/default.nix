{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2021.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g6SpCJS/OOJDzwUsi1jzgb/pp6SD9qnKsUC8f3AqxNo=";
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
