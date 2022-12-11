{ lib
, buildPythonPackage
, c-ares
, cffi
, fetchPypi
, idna
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "4.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4fV6gAQ3AIBpS9b7lpof/JFxpZxoJNVPeRwbLk0pg4U=";
  };

  buildInputs = [
    c-ares
  ];

  propagatedBuildInputs = [
    cffi
    idna
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  # Requires network access
  doCheck = false;

  pythonImportsCheck = [
    "pycares"
  ];

  meta = with lib; {
    description = "Python interface for c-ares";
    homepage = "https://github.com/saghul/pycares";
    changelog = "https://github.com/saghul/pycares/releases/tag/pycares-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
