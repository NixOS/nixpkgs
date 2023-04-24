{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "haversine";
  version = "2.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mapado";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cwvTs/91eJhjmeuCQAUBgfnKuCiLEg1jSnrXfx9VWkI=";
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
