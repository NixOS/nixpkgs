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
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = version;
    hash = "sha256-IKrAJ4QDcYJRO4hcomL9FRs8hJ3k7SgRgK4H1b8SxIM=";
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
      --replace "--cov=aiosteamist" "" \
      --replace 'xmltodict = "^0.12.0"' 'xmltodict = "*"'
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
