{ lib, buildPythonPackage, fetchPypi, dill }:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ip5caz67b3q0553mr8gm8xwsb8x500jn8ml0gihgyfy52m2ypcq";
  };

  propagatedBuildInputs = [ dill ];

  # Python-version dependent tests
  doCheck = false;

  meta = with lib; {
    description = "Better multiprocessing and multithreading in python";
    homepage = https://github.com/uqfoundation/multiprocess;
    license = licenses.bsd3;
  };
}
