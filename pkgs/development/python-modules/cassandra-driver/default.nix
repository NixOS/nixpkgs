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
    sha256 = "1gjs2lqy0ba6zhh13a1dhirk59i7lc4zcbl7h50619hdm5kv3g22";
  };

  buildInputs = [
    pkgs.libev
    # NOTE: next version will work with cython 0.29
    # Requires 'Cython!=0.25,<0.29,>=0.20'
    (cython.overridePythonAttrs(old: rec {
      pname = "Cython";
      version = "0.28.3";
      src = fetchPypi {
        inherit pname version;
        sha256 = "1aae6d6e9858888144cea147eb5e677830f45faaff3d305d77378c3cba55f526";
      };
    }))
  ];

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
