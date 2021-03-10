{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pytest, nose, glibcLocales
, numpy, scipy, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.5.21";

  # Python 2 not supported and not some old Python 3 because MPL doesn't support
  # them properly.
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d86e9ae73e6472c26aeb4de7abd9bf99492fedcbb0485ed7fa23609d2673b42";
  };

  checkInputs = [ pytest nose glibcLocales ];
  propagatedBuildInputs = [ numpy scipy matplotlib h5py ];

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest -k 'not test_message_to_parents'
  '';

  meta = with lib; {
    homepage = "http://www.bayespy.org";
    description = "Variational Bayesian inference tools for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
