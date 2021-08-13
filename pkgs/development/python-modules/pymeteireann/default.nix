{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytz
, xmltodict
}:

buildPythonPackage rec {
  pname = "pymeteireann";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "DylanGore";
    repo = "PyMetEireann";
    rev = version;
    sha256 = "sha256-Y0qB5RZykuBk/PNtxikxjsv672NhS6yJWJeSdAe/MoU=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    pytz
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "meteireann" ];

  meta = with lib; {
    description = "Python module to communicate with the Met Éireann Public Weather Forecast API";
    homepage = "https://github.com/DylanGore/PyMetEireann/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
