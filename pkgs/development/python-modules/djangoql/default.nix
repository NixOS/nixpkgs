{ lib, buildPythonPackage, fetchPypi, python
, django, ply }:

buildPythonPackage rec {
  pname = "djangoql";
  version = "0.12.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mwv1ljznj9mn74ncvcyfmj6ygs8xm2rajpxm88gcac9hhdmk5gs";
  };

  propagatedBuildInputs = [ ply ];

  checkInputs = [ django ];

  checkPhase = ''
    export PYTHONPATH=test_project:$PYTHONPATH
    ${python.executable} test_project/manage.py test core.tests
  '';

  meta = with lib; {
    description = "Advanced search language for Django";
    homepage = https://github.com/ivelum/djangoql;
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
