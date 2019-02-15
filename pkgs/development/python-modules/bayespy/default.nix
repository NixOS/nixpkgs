{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pytest
, numpy, scipy, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.5.18";

  # Python 2 not supported and not some old Python 3 because MPL doesn't support
  # them properly.
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86c453d827b8d6c3574ec306f6fadfc5028614e1cd46676841336e6787a7496a";
  };

  checkInputs = [ pytest  ];
  propagatedBuildInputs = [ numpy scipy matplotlib h5py ];

  checkPhase = ''
  '';

  meta = with stdenv.lib; {
    homepage = http://www.bayespy.org;
    description = "Variational Bayesian inference tools for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
