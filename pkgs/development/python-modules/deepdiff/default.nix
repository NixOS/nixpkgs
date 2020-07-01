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
  version = "4.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91360be1d9d93b1d9c13ae9c5048fa83d9cff17a88eb30afaa0d7ff2d0fee17d";
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
