{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2022.2.1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cea221417204f2d1a2aa03ddae3e867921971d0d76f14d87abb4414415bbdcf5";
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
