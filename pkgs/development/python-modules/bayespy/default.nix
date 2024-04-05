{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder
, pytestCheckHook, nose, glibcLocales, fetchpatch
, numpy, scipy, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.6.1";
  format = "setuptools";

  # Python 2 not supported and not some old Python 3 because MPL doesn't support
  # them properly.
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3N8w/LiTLsDZbHp3z26FvDg3vStB2l3XkIWx+Mma1G0=";
  };

  nativeCheckInputs = [ pytestCheckHook nose glibcLocales ];

  propagatedBuildInputs = [ numpy scipy matplotlib h5py ];

  disabledTests = [
    # Assertion error
    "test_message_to_parents"
  ];

  pythonImportsCheck = [ "bayespy" ];

  meta = with lib; {
    homepage = "http://www.bayespy.org";
    description = "Variational Bayesian inference tools for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
