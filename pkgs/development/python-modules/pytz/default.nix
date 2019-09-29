{ lib, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2019.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ckb27hhjc8i8gcdvk4d9avld62b7k52yjijc60s2m3y8cpb7h16";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s pytz/tests
  '';

  meta = with lib; {
    description = "World timezone definitions, modern and historical";
    homepage = "https://pythonhosted.org/pytz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
