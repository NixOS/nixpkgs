{ lib, buildPythonPackage, fetchPypi, python
, django, ply }:

buildPythonPackage rec {
  pname = "djangoql";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hkg0zh8w6f4krbrv4nl66blrx48yixgc8ikf915415ghlqfsbjj";
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
