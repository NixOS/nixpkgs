{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01ywyiwqa7nyd4kprqxcycv50xydsi95q3lzidpm2r3kn1byis1y";
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
