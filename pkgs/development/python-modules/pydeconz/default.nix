{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydeconz";
  version = "83";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "deconz";
    rev = "v${version}";
    sha256 = "sha256-PpiVw3jX38kZPFDVvJLb1a6/043BQyGuphf55epr9ys=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydeconz" ];

  meta = with lib; {
    description = "Python library wrapping the Deconz REST API";
    homepage = "https://github.com/Kane610/deconz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
