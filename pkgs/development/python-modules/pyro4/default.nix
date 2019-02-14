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
    sha256 = "3897c0254046d4cb412a4d1a8f2f9c2c1c1ae643a24db07d0abdb51acdb8d7b5";
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
