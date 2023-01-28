{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiohttp
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyaftership";
  version = "21.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-SN7fvI/+VHYn2eYQe5wp6lEZ73YeZbsiPjDiq/Ibk3Q=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace setup.py \
      --replace 'version="main",' 'version="${version}",'
  '';

  pythonImportsCheck = [
    "pyaftership"
  ];

  meta = with lib; {
    description = "Python wrapper package for the AfterShip API";
    homepage = "https://github.com/ludeeus/pyaftership";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
