{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  django,
  ply,
}:

buildPythonPackage rec {
  pname = "djangoql";
  version = "0.19.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vOCdUoV4V7InRPkyQfFtXGKhsRing04civoUvruWTu4=";
  };

  propagatedBuildInputs = [ ply ];

  nativeCheckInputs = [ django ];

  checkPhase = ''
    export PYTHONPATH=test_project:$PYTHONPATH
    ${python.executable} test_project/manage.py test core.tests
  '';

  meta = {
    description = "Advanced search language for Django";
    homepage = "https://github.com/ivelum/djangoql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
}
