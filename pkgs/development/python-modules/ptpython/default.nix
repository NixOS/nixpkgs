{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, appdirs
, importlib-metadata
, jedi
, prompt-toolkit
, pygments
}:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.26";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPsUBlAtw0nZnFfq8G5xFvOy3qyU8C80K65ocIkJ90M=";
  };

  propagatedBuildInputs = [
    appdirs
    jedi
    prompt-toolkit
    pygments
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # no tests to run
  doCheck = false;

  pythonImportsCheck = [
    "ptpython"
  ];

  meta = with lib; {
    description = "An advanced Python REPL";
    homepage = "https://github.com/prompt-toolkit/ptpython";
    changelog = "https://github.com/prompt-toolkit/ptpython/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
