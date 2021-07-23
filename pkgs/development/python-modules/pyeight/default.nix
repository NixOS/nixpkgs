{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyeight";
  version = "0.1.9";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyEight";
    rev = version;
    sha256 = "1ybhs09wyzzaryghd6ijxhajp3677x63c4qzqsgln1mmxhj8wm5k";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyeight" ];

  meta = with lib; {
    description = "Python library to interface with the Eight Sleep API";
    homepage = "https://github.com/mezz64/pyEight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
