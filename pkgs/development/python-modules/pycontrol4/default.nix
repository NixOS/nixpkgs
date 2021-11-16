{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, xmltodict
}:

buildPythonPackage rec {
  pname = "pycontrol4";
  version = "0.3.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lawtancool";
    repo = "pyControl4";
    rev = "v${version}";
    sha256 = "068iiyi17ndv6cv124r5dzvififblbi2zw7jgnzb5xi0q093czkj";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  # tests access network
  doCheck = false;

  pythonImportsCheck = [
    "pyControl4.account"
    "pyControl4.alarm"
    "pyControl4.director"
    "pyControl4.light"
  ];

  meta = with lib; {
    description = "Python 3 asyncio package for interacting with Control4 systems";
    homepage = "https://github.com/lawtancool/pyControl4";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
