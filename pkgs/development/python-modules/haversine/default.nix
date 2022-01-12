{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "haversine";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "mapado";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tHA1Ff/J1mfSnER2X/8e0QyQkuRz1mn8MeGlThVQaSg=";
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
