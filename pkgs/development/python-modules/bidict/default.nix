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
  version = "0.21.3";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1QvYH65140GY/8lJeaDrCTn/mts+8yvMk6kT2LPj7R0=";
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
