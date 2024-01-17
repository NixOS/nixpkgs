{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "haversine";
  version = "2.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mapado";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MKOg2awpamupvuXstiH7VoIY4ax+hy2h2cFXDFKJ2mA=";
  };

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "haversine"
  ];

  meta = with lib; {
    description = "Python module the distance between 2 points on earth";
    homepage = "https://github.com/mapado/haversine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
