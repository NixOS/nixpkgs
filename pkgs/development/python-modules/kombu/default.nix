{ lib, buildPythonPackage, fetchPypi
, amqp
, case
, Pyro4
, pytest
, pytz
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "4.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xlv1rsfc3vn22l35csaj939zygd15nzmxbz3bcl981685vxl71d";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "pytest-sugar" ""
    substituteInPlace requirements/default.txt \
      --replace "amqp==2.5.1" "amqp~=2.5"
  '';

  propagatedBuildInputs = [ amqp ];

  checkInputs = [ pytest case pytz Pyro4 sqlalchemy ];
  # test_redis requires fakeredis, which isn't trivial to package
  checkPhase = ''
    pytest --ignore t/unit/transport/test_redis.py
  '';

  meta = with lib; {
    description = "Messaging library for Python";
    homepage    = https://github.com/celery/kombu;
    license     = licenses.bsd3;
  };
}
