{ lib
, buildPythonPackage
, fetchPypi
, pynose
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytimeparse";
  version = "1.1.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6GE2R3vpJNfmcGRqmFYZV+jKcwjUSEHiH13ep1dVago=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pynose
  ];

  pythonImportsCheck = [
    "pytimeparse"
  ];

  meta = with lib; {
    description = "Library to parse various kinds of time expressions";
    homepage = "https://github.com/wroberts/pytimeparse";
    changelog = "https://github.com/wroberts/pytimeparse/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
