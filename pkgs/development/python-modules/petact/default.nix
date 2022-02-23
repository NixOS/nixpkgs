{ lib
, buildPythonPackage
, fetchPypi
}:

let
  pname = "petact";
  version = "0.1.2";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XcsNRPhqYB5Bot75dwmTzQ6kXHbTfrPzXj3WGqUDUOY=";
  };

  doCheck = false;

  pythonImportsCheck = [
    "petact"
  ];

  meta = with lib; {
    description = "A package extraction tool";
    homepage = "https://github.com/matthewscholefield/petact";
    license = licenses.mit;
    maintainers = teams.mycroft.members;
  };
}
