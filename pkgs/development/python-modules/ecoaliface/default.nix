{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "ecoaliface";
  version = "0.5.0";

  src = fetchFromGitHub {
     owner = "matkor";
     repo = "ecoaliface";
     rev = "v0.5.0";
     sha256 = "0r3k53gdp122ig595fqkqg1gnqfgv8rr6b63jg83gfzr2hf4gw9b";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ecoaliface" ];

  meta = with lib; {
    description = "Python library for interacting with eCoal water boiler controllers";
    homepage = "https://github.com/matkor/ecoaliface";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
