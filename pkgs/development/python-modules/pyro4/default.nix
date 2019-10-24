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
, isPy33
, selectors34
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
  ] ++ lib.optionals (isPy27 || isPy33) [ selectors34 ];

  buildInputs = [
    dill
    cloudpickle
    msgpack
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = with stdenv.lib; {
    description = "Distributed object middleware for Python (RPC)";
    homepage = https://github.com/irmen/Pyro4;
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    };
}
