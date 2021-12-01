{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, hypothesis
, py
, pytestCheckHook
, pytest-benchmark
, sortedcollections
, sortedcontainers
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.21.4";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QshP++b43omK9gc7S+nqfM7c1400dKqETFTknVoHn28=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  checkInputs = [
    hypothesis
    py
    pytestCheckHook
    pytest-benchmark
    sortedcollections
    sortedcontainers
  ];

  pythonImportsCheck = [ "bidict" ];

  meta = with lib; {
    homepage = "https://github.com/jab/bidict";
    description = "Efficient, Pythonic bidirectional map data structures and related functionality";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
