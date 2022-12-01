{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "pytado";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    # Upstream hasn't tagged 0.13.0 yet
    rev = "2a243174e9ae01ef7adae940ecc6e340992ab28d";
    sha256 = "Y1FxEzs/AF0ZTPdOK/1v+2U2fidfu+AmZbPddJCWIFc=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
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
