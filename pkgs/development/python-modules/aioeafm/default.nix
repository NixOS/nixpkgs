{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioeafm";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = version;
    sha256 = "048cxn3fw2hynp27zlizq7k8ps67qq9sib1ddgirnxy5zc87vgkc";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioeafm" ];

  meta = with lib; {
    description = "Python client for access the Real Time flood monitoring API";
    homepage = "https://github.com/Jc2k/aioeafm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
