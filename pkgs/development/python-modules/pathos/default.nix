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
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "954c5b0a8b257c375e35d311c65fa62a210a3d65269195557de38418ac9f61f9";
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
