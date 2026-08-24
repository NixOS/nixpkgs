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
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7Oef0ZC/0ZiUfjBHDEsmptXfGGHVQwlDDdkm7VFjAv8=";
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

  meta = {
    description = "Real-time monitor and web admin for Celery distributed task queue";
    homepage = "https://github.com/mher/flower";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
}
