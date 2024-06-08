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
  version = "1.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "laundrify";
    repo = "laundrify-pypi";
    rev = "v${version}";
    hash = "sha256-+dTvYn4hux3Y19kWZwxhdkBARmfD8SuNlYWM/ET9K2M=";
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
