{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, sphinx
, hypothesis
, py
, pytest-xdist
, pytestCheckHook
, pytest-benchmark
, sortedcollections
, sortedcontainers
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.22.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jab";
    repo = "bidict";
    rev = "refs/tags/v${version}";
    hash = "sha256-mPBruasjQwErl5M91OBf71hArztdRVONOCnqos180DY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    sphinx
  ];

  nativeCheckInputs = [
    hypothesis
    py
    pytest-xdist
    pytestCheckHook
    pytest-benchmark
    sortedcollections
    sortedcontainers
  ];

  pythonImportsCheck = [ "bidict" ];

  meta = with lib; {
    homepage = "https://github.com/jab/bidict";
    changelog = "https://github.com/jab/bidict/blob/v${version}/CHANGELOG.rst";
    description = "Efficient, Pythonic bidirectional map data structures and related functionality";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
