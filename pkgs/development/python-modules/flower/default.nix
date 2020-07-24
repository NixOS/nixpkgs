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
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "171zckhk9ni14f1d82wf62hhciy0gx13fd02sr9m9qlj50fnv4an";
  };

  postPatch = ''
    # rely on using example programs (flowers/examples/tasks.py) which
    # are not part of the distribution
    rm tests/load.py
  '';

  propagatedBuildInputs = [
    celery
    pytz
    tornado
    humanize
    prometheus_client
  ];

  checkInputs = [ mock ];

  meta = with lib; {
    description = "Celery Flower";
    homepage = "https://github.com/mher/flower";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
