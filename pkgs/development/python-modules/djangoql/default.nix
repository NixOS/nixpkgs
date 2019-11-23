{ lib, buildPythonPackage, fetchPypi, python
, django, ply }:

buildPythonPackage rec {
  pname = "djangoql";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "366293d7d4e416f9f7d6e2b98775c2129222fbb4dc660f3e6c7b9e35a3cf3fce";
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
