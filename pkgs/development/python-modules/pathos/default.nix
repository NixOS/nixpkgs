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
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21ae2cb1d5a76dcf57d5fe93ae8719c7339f467e246163650c08ccf35b87c846";
  };

  propagatedBuildInputs = [ dill pox ppft multiprocess ];

  # Require network
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Parallel graph management and execution in heterogeneous computing";
    homepage = https://github.com/uqfoundation/pathos/;
    license = licenses.bsd3;
  };

}
