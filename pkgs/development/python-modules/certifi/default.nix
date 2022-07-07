{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2022.05.18.1";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-certifi";
    rev = version;
    sha256 = "sha256-uDNVzKcT45mz0zXBwPkttKV21fEcgbRamE3+QutNLjA=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "certifi" ];

  meta = with lib; {
    homepage = "https://github.com/certifi/python-certifi";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.isc;
    maintainers = with maintainers; [ koral SuperSandro2000 ];
  };
}
