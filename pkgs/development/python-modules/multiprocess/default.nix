{ lib, buildPythonPackage, fetchPypi, dill }:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fd5bd990132da77e73dec6e9613408602a4612e1d73caf2e2b813d2b61508e5";
  };

  propagatedBuildInputs = [ dill ];

  # Python-version dependent tests
  doCheck = false;

  meta = with lib; {
    description = "Better multiprocessing and multithreading in python";
    homepage = "https://github.com/uqfoundation/multiprocess";
    license = licenses.bsd3;
  };
}
