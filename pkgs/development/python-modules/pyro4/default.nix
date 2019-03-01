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

  name = "${pname}-${version}";
  pname = "Pyro4";
  version = "4.75";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dfpp36imddx19yv0kd28gk1l71ckhpqy6jd590wpm2680jw15rq";
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
