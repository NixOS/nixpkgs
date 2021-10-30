{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ovoenergy";
  version = "1.1.12";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "v${version}";
    sha256 = "1430k699gblxwspsbgxnha8afk6npqharhz2jyjw5gir9pi6g9cz";
  };

  propagatedBuildInputs = [
    aiohttp
    click
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ovoenergy" ];

  meta = with lib; {
    description = "Python client for getting data from OVO's API";
    homepage = "https://github.com/timmo001/ovoenergy";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
