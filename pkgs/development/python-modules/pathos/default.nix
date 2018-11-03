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
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e35418af733bf434da83746d46acca94375d6e306b3df330b2a1808db026a188";
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
