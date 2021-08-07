{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, aiohttp
, async-timeout
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyaftership";
  version = "21.1.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "0jyzgwaijkp80whi58a0hgjzmnlczmd9vwn11z2m0j01kbdwznn5";
  };

  propagatedBuildInputs = [ aiohttp async-timeout ];

  checkInputs = [ pytestCheckHook aresponses pytest-asyncio ];
  pythonImportsCheck = [ "pyaftership" ];

  meta = with lib; {
    description = "Python wrapper package for the AfterShip API";
    homepage = "https://github.com/ludeeus/pyaftership";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
