{ lib
, buildPythonPackage
, fetchPypi
, mock
, jsonpickle
, mmh3
, ordered-set
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2b74af4da0ef9cd338bb6e8c97242c1ec9d81fcb28298d7bb24acdc19ea79d7";
  };

  # # Extra packages (may not be necessary)
  checkInputs = [
    mock
    numpy
    pytestCheckHook
  ];

  requiredPythonModules = [
    jsonpickle
    mmh3
    ordered-set
  ];

  meta = with lib; {
    description = "Deep Difference and Search of any Python object/data";
    homepage = "https://github.com/seperman/deepdiff";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
