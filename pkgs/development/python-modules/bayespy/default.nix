{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder
, pytest, nose, glibcLocales
, numpy, scipy, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.5.22";

  # Python 2 not supported and not some old Python 3 because MPL doesn't support
  # them properly.
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed0057dc22bd392df4b3bba23536117e1b2866e3201b12c5a37428d23421a5ba";
  };

  checkInputs = [ pytest nose glibcLocales ];
  propagatedBuildInputs = [ numpy scipy matplotlib h5py ];

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest -k 'not test_message_to_parents'
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    homepage = "http://www.bayespy.org";
    description = "Variational Bayesian inference tools for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
