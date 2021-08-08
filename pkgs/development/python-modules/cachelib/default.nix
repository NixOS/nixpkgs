{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-xprocess
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cachelib";
  version = "0.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = pname;
    rev = version;
    sha256 = "1jh1ghvrv1mnw6mdq19s6x6fblz9qi0vskc6mjp0cxjpnxxblaml";
  };

  checkInputs = [
    pytest-xprocess
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cachelib" ];

  meta = with lib; {
    homepage = "https://github.com/pallets/cachelib";
    description = "Collection of cache libraries in the same API interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
  };
}
