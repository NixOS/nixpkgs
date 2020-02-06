{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pytest, glibcLocales
, numpy, scipy, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.5.19";

  # Python 2 not supported and not some old Python 3 because MPL doesn't support
  # them properly.
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24e1327ce241a0113abf217fbaf41ac25e04f5a01f9ed606610f2f1f2d82d34f";
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
