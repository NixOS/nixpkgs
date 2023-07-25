{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "pytado";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    # Upstream hasn't tagged 0.13.0 yet
    rev = "refs/tags/${version}";
    sha256 = "sha256-tpWr+VlkJ9svN9XtBIDEAos4uxYCl6njvUBPIJG++Yg=";
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
