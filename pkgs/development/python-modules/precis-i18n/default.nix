{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "precis-i18n";
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "byllyfish";
    repo = "precis_i18n";
    rev = "refs/tags/v${version}";
    hash = "sha256-DSm+KomveGs9ZzNFiT0B1gAjx2fh0BaUdKW0J+kW24U=";
  };

  pythonImportsCheck = [
    "precis_i18n"
  ];

  meta = with lib; {
    homepage = "https://github.com/byllyfish/precis_i18n";
    description = "Internationalized usernames and passwords";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
