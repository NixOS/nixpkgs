{ lib, buildPythonPackage, fetchPypi
, setuptools-scm
, sphinx
, hypothesis
, py
, pytestCheckHook
, pytest-benchmark
, sortedcollections
, sortedcontainers
, isPy3k
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.21.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4fa46f7ff96dc244abfc437383d987404ae861df797e2fd5b190e233c302be09";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ sphinx ];

  checkInputs = [
    hypothesis
    py
    pytestCheckHook
    pytest-benchmark
    sortedcollections
    sortedcontainers
  ];

  meta = with lib; {
    homepage = "https://github.com/jab/bidict";
    description = "Efficient, Pythonic bidirectional map data structures and related functionality";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
