{ lib
, buildPythonPackage
, fetchPypi
, mock
, jsonpickle
, ordered-set
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "4.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e2343398e90538edaa59c0c99207e996a3a834fdc878c666376f632a760c35a";
  };

  # # Extra packages (may not be necessary)
  checkInputs = [
    mock
    numpy
    pytestCheckHook
  ];

  disabledTests = [
    # skipped tests require murmur module
    "test_prep_str_murmur3_64bit"
    "test_prep_str_murmur3_128bit"
  ];

  propagatedBuildInputs = [
    jsonpickle
    ordered-set
  ];

  meta = with lib; {
    description = "Deep Difference and Search of any Python object/data";
    homepage = "https://github.com/seperman/deepdiff";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
