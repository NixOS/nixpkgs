{ aiohttp, aresponses, buildPythonPackage, fetchFromGitHub, isPy3k, lib
, pytest-asyncio, pytestCheckHook, yarl }:

buildPythonPackage rec {
  pname = "adguardhome";
  version = "0.4.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0lcf3yg27amrnqvgn5nw4jn2j0vj4yfmyl5p5yncmn7dh6bdbsp8";
  };

  propagatedBuildInputs = [ aiohttp yarl ];
  checkInputs = [ aresponses pytest-asyncio pytestCheckHook ];

  meta = with lib; {
    description = "Asynchronous Python client for the AdGuard Home API.";
    homepage = "https://github.com/frenck/python-adguardhome";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
