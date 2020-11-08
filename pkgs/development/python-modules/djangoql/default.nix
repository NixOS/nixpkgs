{ lib, buildPythonPackage, fetchPypi, python
, django, ply }:

buildPythonPackage rec {
  pname = "djangoql";
  version = "0.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91fd65d9ee4b09092602ff05aca8a21c5a18062faf56f269a011b8e8e41483c6";
  };

  requiredPythonModules = [ ply ];

  checkInputs = [ django ];

  checkPhase = ''
    export PYTHONPATH=test_project:$PYTHONPATH
    ${python.executable} test_project/manage.py test core.tests
  '';

  meta = with lib; {
    description = "Advanced search language for Django";
    homepage = "https://github.com/ivelum/djangoql";
    license = licenses.mit;
    maintainers = with maintainers; [ earvstedt ];
  };
}
