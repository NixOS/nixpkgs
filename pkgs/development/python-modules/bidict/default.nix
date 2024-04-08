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
, typing-extensions
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.23.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jab";
    repo = "bidict";
    rev = "refs/tags/v${version}";
    hash = "sha256-WE0YaRT4a/byvU2pzcByuf1DfMlOpYA9i0PPrKXsS+M=";
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
    typing-extensions
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
