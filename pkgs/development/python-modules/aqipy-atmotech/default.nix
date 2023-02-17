{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aqipy-atmotech";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "atmotube";
    repo = "aqipy";
    rev = version;
    hash = "sha256-tqHhfJmtVFUSO57Cid9y3LK4pOoG7ROtwDT2hY5IE1Y=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  pythonImportsCheck = [
    "aqipy"
  ];

  meta = with lib; {
    description = "Library for AQI calculation";
    homepage = "https://github.com/atmotube/aqipy";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
