{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, scipy, numpy, matplotlib, tables, pyaml, urllib3, rpy2, mpi4py }:

buildPythonPackage rec {
  pname = "NeuroTools";
  version = "0.3.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ly6qa87l3afhksab06vp1iimlbm1kdnsw98mxcnpzz9q07l4nd4";
  };

  # Tests are not automatically run
  # Many tests fail (using py.test), and some need R
  doCheck = false;

  propagatedBuildInputs = [
    scipy
    numpy
    matplotlib
    tables
    pyaml
    urllib3
    rpy2
    mpi4py
  ];

  meta = with stdenv.lib; {
    description = "Collection of tools to support analysis of neural activity";
    homepage = https://pypi.python.org/pypi/NeuroTools;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nico202 ];
  };
}
