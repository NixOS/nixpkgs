{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "haversine";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "mapado";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cFb2DsXIwaaJK3tiOTCc0k45FVJ4/Vudkq0rzqalGJs=";
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
