{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, babelfish
, rebulk
, pythonOlder
, importlib-resources
, pytestCheckHook
, pytest-mock
, pytest-benchmark
, pyyaml
}:

buildPythonPackage rec {
  pname = "guessit";
  version = "3.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "731e96e6a1f3b065d05accc8c19f35d4485d880b77ab8dc4b262cc353df294f7";
  };

  propagatedBuildInputs = [
    rebulk
    babelfish
    python-dateutil
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  checkInputs = [ pytestCheckHook pytest-mock pytest-benchmark pyyaml ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "guessit" ];

  meta = {
    homepage = "https://doc.guessit.io/";
    description = "A Python library that extracts as much information as possible from a video filename";
    changelog = "https://github.com/guessit-io/guessit/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
  };
}
