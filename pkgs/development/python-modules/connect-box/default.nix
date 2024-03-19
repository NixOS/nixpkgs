{ lib
, aiohttp
, attrs
, buildPythonPackage
, defusedxml
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "connect-box";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "connect_box";
    inherit version;
    hash = "sha256-raekHxzju9NrFXasA/MqGvjGjAPzJDt2YX8c/T3ncbw=";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    defusedxml
  ];

  # No tests are present
  doCheck = false;

  pythonImportsCheck = [
    "connect_box"
  ];

  meta = with lib; {
    description = "Interact with a Compal CH7465LG cable modem/router";
    longDescription = ''
      Python Client for interacting with the cable modem/router Compal
      CH7465LG which is provided under different names by various ISP
      in Europe, e.g., UPC Connect Box (CH), Irish Virgin Media Super
      Hub 3.0 (IE), Ziggo Connectbox (NL) or Unitymedia Connect Box (DE).
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-connect-box";
    changelog = "https://github.com/home-assistant-ecosystem/python-connect-box/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
