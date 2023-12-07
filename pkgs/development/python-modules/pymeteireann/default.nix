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
  version = "2021.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "DylanGore";
    repo = "PyMetEireann";
    rev = version;
    sha256 = "1xcfb3f2a2q99i8anpdzq8s743jgkk2a3rpar48b2dhs7l15rbsd";
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
