{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder
, pytestCheckHook, nose, glibcLocales, fetchpatch
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

  patches = [
    # Change from scipy to locally defined epsilon
    # https://github.com/bayespy/bayespy/pull/126
    (fetchpatch {
      name = "locally-defined-epsilon.patch";
      url = "https://github.com/bayespy/bayespy/commit/9be53bada763e19c2b6086731a6aa542ad33aad0.patch";
      sha256 = "sha256-KYt/0GcaNWR9K9/uS2OXgK7g1Z+Bayx9+IQGU75Mpuo=";
    })
  ];

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
