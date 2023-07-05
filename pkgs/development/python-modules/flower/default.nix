{ lib
, buildPythonPackage
, fetchPypi
, celery
, humanize
, pytz
, tornado
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flower";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Vld4XXKKVJFCVsNP0FUf4tcVKqsIBi68ZFv4a5e4rsU=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flower"
  ];

  meta = with lib; {
    description = "Real-time monitor and web admin for Celery distributed task queue";
    homepage = "https://github.com/mher/flower";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
