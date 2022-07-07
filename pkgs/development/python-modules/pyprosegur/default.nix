{ lib
, aiohttp
, backoff
, buildPythonPackage
, click
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyprosegur";
  version = "0.0.5";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = pname;
    rev = version;
    sha256 = "0bpzxm8s548fw6j36brp7bcx9481x2hrypcw3yyg4ihsjhka5qln";
  };

  propagatedBuildInputs = [
    aiohttp
    backoff
    click
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyprosegur" ];

  meta = with lib; {
    description = "Python module to communicate with Prosegur Residential Alarms";
    homepage = "https://github.com/dgomes/pyprosegur";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
