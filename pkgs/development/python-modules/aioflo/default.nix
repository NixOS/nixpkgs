{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioflo";
  version = "2021.10.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-BunTgK8IS9uE8y/LMk7624kunouNAWNqe3Xm2DjQ1pY=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioflo" ];

  meta = with lib; {
    description = "Python library for Flo by Moen Smart Water Detectors";
    homepage = "https://github.com/bachya/aioflo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
