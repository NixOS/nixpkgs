{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, attrs
, defusedxml
}:

buildPythonPackage rec {
  pname = "connect-box";
  version = "0.2.8";

  src = fetchPypi {
    pname = "connect_box";
    inherit version;
    sha256 = "1lvz7g2f0a9ifnjczmbavn105miirdgyayr4sixhzgdgadcdhz3l";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    defusedxml
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [ "connect_box" ];

  meta = with lib; {
    description = "Interact with a Compal CH7465LG cable modem/router";
    longDescription = ''
      Python Client for interacting with the cable modem/router Compal
      CH7465LG which is provided under different names by various ISP
      in Europe, e.g., UPC Connect Box (CH), Irish Virgin Media Super
      Hub 3.0 (IE), Ziggo Connectbox (NL) or Unitymedia Connect Box (DE).
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-connect-box";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
