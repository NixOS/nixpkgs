{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2021.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326";
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
