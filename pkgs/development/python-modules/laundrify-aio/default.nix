{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aiohttp,
  pyjwt,
}:

buildPythonPackage rec {
  pname = "laundrify-aio";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "laundrify";
    repo = "laundrify-pypi";
    rev = "v${version}";
    hash = "sha256-mIdw2167H4Ume/DqV+fjRiBrph+8Jj5EEUALDDj4ah8=";
  };

  propagatedBuildInputs = [
    aiohttp
    pyjwt
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "laundrify_aio" ];

  meta = with lib; {
    description = "Module to communicate with the laundrify API";
    homepage = "https://github.com/laundrify/laundrify-pypi";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
