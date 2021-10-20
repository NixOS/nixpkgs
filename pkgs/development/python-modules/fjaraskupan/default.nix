{ lib
, bleak
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fjaraskupan";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = pname;
    rev = version;
    sha256 = "sha256-nUrgV4keJpYRkKZE+udvmPdCW3O3YQTS1ye40IdA7vA=";
  };

  propagatedBuildInputs = [
    bleak
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fjaraskupan" ];

  meta = with lib; {
    description = "Python module for controlling Fjäråskupan kitchen fans";
    homepage = "https://github.com/elupus/fjaraskupan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
