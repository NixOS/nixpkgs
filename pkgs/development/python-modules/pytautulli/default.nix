{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytautulli";
  version = "21.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-zODU3aN+8Fdw/GQ/EfZhn6kOuLDARKgLULzRw2+b2BM=";
  };

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace setup.py \
      --replace 'version="main",' 'version="${version}",'
  '';

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  pythonImportsCheck = [
    "pytautulli"
  ];

  meta = with lib; {
    description = "Python module to get information from Tautulli";
    homepage = "https://github.com/ludeeus/pytautulli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
