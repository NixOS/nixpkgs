{
  lib,
  aiohttp,
  brotlipy,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "garminconnect-aio";
  version = "0.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

<<<<<<< HEAD
  meta = {
    description = "Python module to interact with Garmin Connect";
    homepage = "https://github.com/cyberjunky/python-garminconnect-aio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module to interact with Garmin Connect";
    homepage = "https://github.com/cyberjunky/python-garminconnect-aio";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
