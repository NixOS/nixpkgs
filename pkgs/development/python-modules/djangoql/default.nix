{ lib, buildPythonPackage, fetchPypi, python
, django, ply }:

buildPythonPackage rec {
  pname = "djangoql";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8f06f1fc3a07dfabee75a99852693537805e580f21f3d81abe9e46269503438";
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
