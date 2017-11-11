{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pytest, glibcLocales
, numpy, scipy, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.5.12";
  name = "${pname}-${version}";

  # Python 2 not supported and not some old Python 3 because MPL doesn't support
  # them properly.
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9609a3e85f88434a47c8263f40567cd24363d0e10d236354630b670fca313c00";
  };

  checkInputs = [ pytest glibcLocales ];
  propagatedBuildInputs = [ numpy scipy matplotlib h5py ];

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest -k 'not test_message_to_parents'
  '';

  meta = with stdenv.lib; {
    homepage = http://www.bayespy.org;
    description = "Variational Bayesian inference tools for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
