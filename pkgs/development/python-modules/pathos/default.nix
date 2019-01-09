{ stdenv
, buildPythonPackage
, fetchPypi
, dill
, pox
, ppft
, multiprocess
}:

buildPythonPackage rec {
  pname = "pathos";
  version = "0.2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69486cfe8c9fbd028395df445e4205ea3001d7ca5608d8d0b67b67ce98bb8892";
  };

  propagatedBuildInputs = [ dill pox ppft multiprocess ];

  # Require network
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Parallel graph management and execution in heterogeneous computing";
    homepage = http://www.cacr.caltech.edu/~mmckerns/pathos.htm;
    license = licenses.bsd3;
  };

}
