{ lib, aiohttp, buildPythonPackage, certifi, fetchFromGitHub, pythonOlder }:

buildPythonPackage rec {
  pname = "crownstone-sse";
  version = "2.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-sse";
    rev = version;
    sha256 = "sha256-O1joOH7HCXYCro26p6foMMpg0UXfOgXD0BXuN50OK7U=";
  };

  propagatedBuildInputs = [ aiohttp certifi ];

  # Tests are only providing coverage
  doCheck = false;

  pythonImportsCheck = [ "crownstone_sse" ];

  meta = with lib; {
    description = "Python module for listening to Crownstone SSE events";
    homepage = "https://github.com/crownstone/crownstone-lib-python-sse";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
