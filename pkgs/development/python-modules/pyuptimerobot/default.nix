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
  pname = "pyuptimerobot";
  version = "22.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-QZm8FlUm17Vv80hB3iai54QcVlhSrq2AvbdBaRWDyok=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aresponses
    pytestCheckHook
    pytest-asyncio
  ];

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace setup.py \
      --replace 'version="main",' 'version="${version}",'
  '';

  pythonImportsCheck = [
    "pyuptimerobot"
  ];

  meta = with lib; {
    description = "Python API wrapper for Uptime Robot";
    homepage = "https://github.com/ludeeus/pyuptimerobot";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
