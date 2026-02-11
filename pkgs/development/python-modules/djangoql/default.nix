{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  django,
  setuptools,
  ply,
}:

buildPythonPackage (finalAttrs: {
  pname = "djangoql";
  version = "0.19.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vOCdUoV4V7InRPkyQfFtXGKhsRing04civoUvruWTu4=";
  };

  build-system = [ setuptools ];

  dependencies = [ ply ];

  nativeCheckInputs = [ django ];

  checkPhase = ''
    export PYTHONPATH=test_project:$PYTHONPATH
    ${python.executable} test_project/manage.py test core.tests
  '';

  pythonImportsCheck = [ "djangoql" ];

  meta = {
    description = "Advanced search language for Django";
    homepage = "https://github.com/ivelum/djangoql";
    changelog = "https://github.com/ivelum/djangoql/blob/master/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
})
