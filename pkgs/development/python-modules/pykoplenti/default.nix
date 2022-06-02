{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, prompt-toolkit
, pycryptodome
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pykoplenti";
  version = "1.0.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stegm";
    repo = pname;
    rev = "v${version}";
    sha256 = "12nsyz8a49vhby1jp991vaky82fm93jrgcsjzwa2rixwg1zql4sw";
  };

  propagatedBuildInputs = [
    aiohttp
    click
    prompt-toolkit
    pycryptodome
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykoplenti" ];

  meta = with lib; {
    description = "Python REST client API for Kostal Plenticore Inverters";
    homepage = "https://github.com/stegm/pykoplenti/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
