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
  version = "4.74";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89ed7b12c162e5124f322f992f9506c44f5e1a379926cf01ee73ef810d3bf75f";
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
