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
  version = "0.2.4";
  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hfurubotten";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Y2sBPikCAxumylP1LUy8XgjBRCWaNryn5XHSrRjJIIo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'async_timeout = "^3.0.1"' 'async_timeout = ">=3.0.1"'
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "enturclient"
  ];

  meta = with lib; {
    description = "Python library for interacting with the Entur.org API";
    homepage = "https://github.com/hfurubotten/enturclient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
