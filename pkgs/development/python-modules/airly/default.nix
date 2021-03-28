{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "airly";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ak-ambi";
    repo = "python-airly";
    rev = "v${version}";
    sha256 = "0an6nbl0i5pahxm6x4z03s9apzgqrw9zf7srjcs0r3y1ppicb4s6";
  };

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [ pytestCheckHook ];

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
