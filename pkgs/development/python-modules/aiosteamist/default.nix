{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "aiosteamist";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = version;
    hash = "sha256-VoIJh3EDBPKmvEmM3gP2pyt/0oz4i6Y0zIkkprTcFLg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=aiosteamist" ""
  '';

  pythonImportsCheck = [
    "aiosteamist"
  ];

  # Modules doesn't have test suite
  doCheck = false;

  meta = with lib; {
    description = "Module to control Steamist steam systems";
    homepage = "https://github.com/bdraco/aiosteamist";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
