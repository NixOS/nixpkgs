{
  lib,
  buildPythonPackage,
  fetchPypi,
  celery,
  humanize,
  pytz,
  tornado,
  prometheus-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flower";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WrcXuXlTB3DBavtItQ0qmNI8Pp/jmFHc9rxNAYRaAqA=";
  };

  postPatch = ''
    # rely on using example programs (flowers/examples/tasks.py) which
    # are not part of the distribution
    rm tests/load.py
  '';

  propagatedBuildInputs = [
    celery
    humanize
    prometheus-client
    pytz
    tornado
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flower" ];

  meta = with lib; {
    description = "Real-time monitor and web admin for Celery distributed task queue";
    homepage = "https://github.com/mher/flower";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
