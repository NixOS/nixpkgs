{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "jab";
     repo = "bidict";
     rev = "v0.21.4";
     sha256 = "1hh40q05k0bh2kp8shsa47hka1bp982np5zldswvqhrhwv4whgi1";
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
