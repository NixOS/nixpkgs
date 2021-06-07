{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, aresponses
, coverage
, mypy
, pytest-asyncio
, pytest-cov
, pytest-mock
, aiohttp
, attrs
, cattrs
, yarl
}:

buildPythonPackage rec {
  pname = "bsblan";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "liudger";
    repo = "python-bsblan";
    rev = "v.${version}";
    sha256 = "0vyg9vsrs34jahlav83qp2djv81p3ks31qz4qh46zdij2nx7l1fv";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    cattrs
    yarl
  ];

  checkInputs = [
    aresponses
    coverage
    mypy
    pytest-asyncio
    pytest-cov
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bsblan" ];

  meta = with lib; {
    description = "Python client for BSB-Lan";
    homepage = "https://github.com/liudger/python-bsblan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
