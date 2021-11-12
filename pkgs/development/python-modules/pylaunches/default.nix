{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylaunches";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "0mczxkwczyh9kva4xzpmnawy0hjha1fdrwj6igip9w5z1q48zs49";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace setup.py \
      --replace 'version="main",' 'version="${version}",' \
      --replace ', "pytest-runner"' ""
  '';

  pythonImportsCheck = [
    "pylaunches"
  ];

  meta = with lib; {
    description = "Python module to get information about upcoming space launches";
    homepage = "https://github.com/ludeeus/pylaunches";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
