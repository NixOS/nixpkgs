{ lib
, buildPythonPackage
, fetchPypi
, celery
, humanize
, mock
, pytz
, tornado
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flower";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gcczr04g7wx99h7pxxx1p9n50sbyi0zxrzy7f7m0sf5apxw85rf";
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

  checkInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError as the celery release can't be detected
    "test_default"
    "test_with_app"
  ];

  pythonImportsCheck = [
    "flower"
  ];

  meta = with lib; {
    description = "Celery Flower";
    homepage = "https://github.com/mher/flower";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
