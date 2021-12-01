{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "enturclient";
  version = "0.2.2";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hfurubotten";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kl44ch8p31pr70yv6na2m0w40frackdwzph9rpb05sc83va701i";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "enturclient" ];

  meta = with lib; {
    description = "Python library for interacting with the Entur.org API";
    homepage = "https://github.com/hfurubotten/enturclient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
