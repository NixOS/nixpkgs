{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "beautifultable";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "pri22296";
    repo = pname;
    rev = "v${version}";
    sha256 = "12ci6jy8qmbphsvzvj98466nlhclfzs0a0pmbsv3mf5bfcdwvbh7";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test.py" ];

  pythonImportsCheck = [ "beautifultable" ];

  meta = with lib; {
    description = "Python package for printing visually appealing tables";
    homepage = "https://github.com/CERT-Polska/mwdblib";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
