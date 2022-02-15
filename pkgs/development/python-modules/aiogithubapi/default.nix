{ lib
, aiohttp
, aresponses
, async-timeout
, backoff
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiogithubapi";
  version = "22.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-2M0EcDs3WmgG2tusvnXK750+ALE93RktlPyQO36+Ojw=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    backoff
  ];

  checkInputs = [
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
    "aiogithubapi"
  ];

  meta = with lib; {
    description = "Python client for the GitHub API";
    homepage = "https://github.com/ludeeus/aiogithubapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
