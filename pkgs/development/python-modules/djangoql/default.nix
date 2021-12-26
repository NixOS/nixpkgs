{ lib, buildPythonPackage, fetchPypi, python
, django, ply }:

buildPythonPackage rec {
  pname = "djangoql";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23cea52eca76e605fa2f34b13ae8d2bf60240737ee9ed3f60c667a4f64d28adf";
  };

  propagatedBuildInputs = [ ply ];

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
