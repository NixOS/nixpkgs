{ lib
, aiohttp
, aresponses
, async-timeout
, backoff
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiogithubapi";
  version = "22.12.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-j7ikJS6lcqr7K4fU/EL43lFlWtGvPT4V9JC2Iqhi0ec=";
  };

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace pyproject.toml \
      --replace 'version = "0"' 'version = "${version}"' \
      --replace 'backoff = "^1.10.0"' 'backoff = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

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

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [
    "aiogithubapi"
  ];

  meta = with lib; {
    description = "Python client for the GitHub API";
    homepage = "https://github.com/ludeeus/aiogithubapi";
    changelog = "https://github.com/ludeeus/aiogithubapi/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
