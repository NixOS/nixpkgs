{ lib
, buildPythonPackage
, c-ares
, cffi
, fetchPypi
, idna
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "4.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4fV6gAQ3AIBpS9b7lpof/JFxpZxoJNVPeRwbLk0pg4U=";
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

  pythonImportsCheck = [ "pycares" ];

  meta = with lib; {
    description = "Python interface for c-ares";
    homepage = "https://github.com/saghul/pycares";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
