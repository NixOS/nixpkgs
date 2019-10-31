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
  version = "4.77";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2bfe12a22f396474b0e57c898c7e2c561a8f850bf2055d8cf0f7119f0c7a523f";
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
    homepage = https://github.com/irmen/Pyro4;
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    };
}
