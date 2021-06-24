{ lib
, buildPythonPackage
, fetchPypi
, celery
, humanize
, mock
, pytz
, tornado
, prometheus_client
}:

buildPythonPackage rec {
  pname = "flower";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf27a254268bb06fd4972408d0518237fcd847f7da4b4cd8055e228150ace8f3";
  };

  postPatch = ''
    # rely on using example programs (flowers/examples/tasks.py) which
    # are not part of the distribution
    rm tests/load.py
    substituteInPlace  requirements/default.txt --replace "prometheus_client==0.8.0" "prometheus_client>=0.8.0"
  '';

  propagatedBuildInputs = [
    celery
    pytz
    tornado
    humanize
    prometheus_client
  ];

  checkInputs = [ mock ];

  pythonImportsCheck = [ "flower" ];

  meta = with lib; {
    description = "Celery Flower";
    homepage = "https://github.com/mher/flower";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
    broken = (celery.version >= "5.0.2"); # currently broken with celery>=5.0 by https://github.com/mher/flower/pull/1021
  };
}
