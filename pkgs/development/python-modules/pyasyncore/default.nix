{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "pyasyncore";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonrob";
    repo = "pyasyncore";
    rev = "v${version}";
    hash = "sha256-8U46q1QIjBkFh04NkAHZ0XRutlzpJHZWAqDZJj3tdEk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "asyncore"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Make asyncore available for Python 3.12 onwards";
    homepage = "https://github.com/simonrob/pyasyncore";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
  };
}
