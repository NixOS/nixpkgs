{ lib
, buildPythonPackage
, fetchPypi
, psutil
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pynisher";
  version = "1.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JyK3ldIhKd3VJHA4u6cnrgbs2zpZQgcIF758jUpoDjE=";
  };

  propagatedBuildInputs = [
    psutil
    typing-extensions
  ];

  # No tests in the Pypi archive
  doCheck = false;

  pythonImportsCheck = [
    "pynisher"
  ];

  meta = with lib; {
    description = "Module intended to limit a functions resources";
    homepage = "https://github.com/automl/pynisher";
    changelog = "https://github.com/automl/pynisher/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
