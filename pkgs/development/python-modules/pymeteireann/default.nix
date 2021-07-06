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
  version = "0.2";

  src = fetchFromGitHub {
    owner = "DylanGore";
    repo = "PyMetEireann";
    rev = version;
    sha256 = "1904f8mvv4ghzbniswmdwyj5v71m6y3yn1b4grjvfds05skalm67";
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
