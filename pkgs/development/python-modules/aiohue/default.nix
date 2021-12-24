{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "3.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Q01giQZytOQ+Ko7kvL0OfdDPysfvtKhW7fYmHmAv5Go=";
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
