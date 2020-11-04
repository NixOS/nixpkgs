{ lib, buildPythonPackage, fetchPypi, python
, django, ply }:

buildPythonPackage rec {
  pname = "djangoql";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b1f80940bb15982e06208b97d7b3d08e1d5f8fb62aa07e5e33599c7ce4c0334";
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
