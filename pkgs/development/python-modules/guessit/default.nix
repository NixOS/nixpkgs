{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, babelfish
, rebulk
, pythonOlder
, importlib-resources
, py
, pytestCheckHook
, pytest-mock
, pytest-benchmark
, pyyaml
}:

buildPythonPackage rec {
  pname = "guessit";
  version = "3.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LBjZgu5tsw211ZVXrdAySitJvzlAp1KUdRBjKitYo8E=";
  };

  propagatedBuildInputs = [
    rebulk
    babelfish
    python-dateutil
  ] ++ lib.optionals (pythonOlder "3.9") [
   importlib-resources
 ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-mock
    pytest-benchmark
    pyyaml
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "guessit" ];

  meta = with lib; {
    description = "A Python library that extracts as much information as possible from a video filename";
    homepage = "https://guessit-io.github.io/guessit/";
    changelog = "https://github.com/guessit-io/guessit/raw/v${version}/CHANGELOG.md";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ ];
  };
}
