{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "haversine";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "mapado";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iAGG1mjrt6oJ0IkmlJwrvb2Bpk4dNxV7ee9LYov03UY=";
  };

  checkInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "haversine" ];

  meta = with lib; {
    description = "Python module the distance between 2 points on earth";
    homepage = "https://github.com/mapado/haversine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
