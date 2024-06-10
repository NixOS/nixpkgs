{
  lib,
  aiohttp,
  aioresponses,
  aiounittest,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "airly";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ak-ambi";
    repo = "python-airly";
    rev = "v${version}";
    hash = "sha256-weliT/FYnRX+pzVAyRWFly7lfj2z7P+hpq5SIhyIgmI=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # aiounittest is not supported on 3.12
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    aioresponses
    aiounittest
    pytestCheckHook
  ];

  preCheck = ''
    cd tests
  '';

  disabledTests = [
    "InstallationsLoaderTestCase"
    "MeasurementsSessionTestCase"
  ];

  pythonImportsCheck = [ "airly" ];

  meta = with lib; {
    description = "Python module for getting air quality data from Airly sensors";
    homepage = "https://github.com/ak-ambi/python-airly";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
