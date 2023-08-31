{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "pytado";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    # Upstream hasn't tagged 0.13.0 yet
    rev = "refs/tags/${version}";
    sha256 = "sha256-w1qtSEpnZCs7+M/0Gywz9AeMxUzz2csHKm9SxBKzmz4=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "PyTado"
  ];

  meta = with lib; {
    description = "Python binding for Tado web API";
    homepage = "https://github.com/wmalgadey/PyTado";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
