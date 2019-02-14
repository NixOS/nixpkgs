{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, cython
, futures
, six
, python
, scales
, eventlet
, twisted
, mock
, gevent
, nose
, pytz
, pyyaml
, sure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cassandra-driver";
  version = "3.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42bcb167a90da6604081872ef609a327a63273842da81120fc462de031155abe";
  };

  buildInputs = [ pkgs.libev cython ];

  propagatedBuildInputs = [ six ]
    ++ stdenv.lib.optionals (pythonOlder "3.4") [ futures ];

  postPatch = ''
    sed -i "s/<=1.0.1//" setup.py
  '';

  checkPhase = ''
    ${python.interpreter} setup.py gevent_nosetests
    ${python.interpreter} setup.py eventlet_nosetests
  '';

  checkInputs = [ scales eventlet twisted mock gevent nose pytz pyyaml sure ];

  # Could not get tests running
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://datastax.github.io/python-driver/;
    description = "A Python client driver for Apache Cassandra";
    license = licenses.asl20;
  };

}
