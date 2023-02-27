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
  version = "0.22.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Hg9/dOSGDm0JQ6BdQTTGOi+thvPUcy+yZb155OhW2B0=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  nativeCheckInputs = [
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
