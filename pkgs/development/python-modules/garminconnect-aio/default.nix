{
  lib,
  aiohttp,
  brotlipy,
  buildPythonPackage,
  fetchFromGitHub,
  yarl,
}:

buildPythonPackage rec {
  pname = "garminconnect-aio";
  version = "0.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect-aio";
    rev = version;
    hash = "sha256-GWY2kTG2D+wOJqM/22pNV5rLvWjAd4jxVGlHBou/T2g=";
  };

  propagatedBuildInputs = [
    aiohttp
    brotlipy
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "garminconnect_aio" ];

  meta = {
    description = "Python module to interact with Garmin Connect";
    homepage = "https://github.com/cyberjunky/python-garminconnect-aio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
