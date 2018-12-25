{ lib
, buildPythonPackage
, fetchPypi
, lupa
, pytest
, redis
, nose
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "005gnzj8lffz6hv5ii980gv8ffsiilqijdifyrz7lnms0c1852ms";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "redis<3" "redis"
  '';

  propagatedBuildInputs = [ lupa redis ];

  checkInputs = [ pytest nose ];

  # test_pubsub_run_in_thread sometimes fails with
  # `RuntimeError: dictionary changed size during iteration`
  # https://github.com/jamesls/fakeredis/issues/230
  #
  # test_pipeline_as_context_manager fails with redis-py 3
  # `AttributeError: module 'redis.client' has no attribute 'BasePipeline'`
  checkPhase = ''
    py.test -v -k "not test_pubsub_run_in_thread and not test_pipeline_as_context_manager"
  '';

  meta = with lib; {
    description = "Fake implementation of redis API (redis-py) for testing purposes";
    homepage = https://github.com/jamesls/fakeredis;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ivan ];
  };
}
