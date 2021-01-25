{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "haversine";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "mapado";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c3yf9162b2b7l1lsw3ffd1linnc542qvljpgwxp6y5arrmljqnv";
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
