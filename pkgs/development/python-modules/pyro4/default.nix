{ stdenv
, buildPythonPackage
, fetchPypi
, lib
, python
, serpent
, dill
, cloudpickle
, msgpack
, isPy27
, selectors34
, pytest
}:

buildPythonPackage rec {
  pname = "Pyro4";
  version = "4.80";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46847ca703de3f483fbd0b2d22622f36eff03e6ef7ec7704d4ecaa3964cb2220";
  };

  propagatedBuildInputs = [
    serpent
  ] ++ lib.optionals isPy27 [ selectors34 ];

  buildInputs = [
    dill
    cloudpickle
    msgpack
  ];

  checkInputs = [ pytest ];
  # add testsupport.py to PATH
  # ignore network related tests, which fail in sandbox
  checkPhase = ''
    PYTHONPATH=tests/PyroTests:$PYTHONPATH
    pytest -k 'not StartNSfunc \
               and not Broadcast \
               and not GetIP' \
           --ignore=tests/PyroTests/test_naming.py
  '';

  meta = with stdenv.lib; {
    description = "Distributed object middleware for Python (RPC)";
    homepage = "https://github.com/irmen/Pyro4";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    };
}
