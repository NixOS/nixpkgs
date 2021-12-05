{ lib, aiohttp, buildPythonPackage, fetchFromGitHub, lxml, pytest-aiohttp
, pytestCheckHook, pythonOlder }:

buildPythonPackage rec {
  pname = "afsapi";
  version = "0.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zhelev";
    repo = "python-afsapi";
    rev = version;
    sha256 = "aevxhHuRedDs0JxeMlYSKHDQwcIs7miRm4FCtssdE0w=";
  };

  propagatedBuildInputs = [ aiohttp lxml ];

  checkInputs = [ pytest-aiohttp pytestCheckHook ];

  pytestFlagsArray = [ "async_tests.py" ];

  pythonImportsCheck = [ "afsapi" ];

  meta = with lib; {
    description = "Python implementation of the Frontier Silicon API";
    homepage = "https://github.com/zhelev/python-afsapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
