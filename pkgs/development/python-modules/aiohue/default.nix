{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "3.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qOtfr6rrV+E/vdY3AprJ5G7p+VzYDVk1aq9/F0O0mLE=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [
    "aiohue"
    "aiohue.discovery"
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Python package to talk to Philips Hue";
    homepage = "https://github.com/home-assistant-libs/aiohue";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
