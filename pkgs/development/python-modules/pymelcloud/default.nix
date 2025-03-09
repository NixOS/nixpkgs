{
  lib,
  aiohttp,
  asynctest,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pymelcloud";
  version = "2.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vilppuvuorinen";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q6ny58cn9qy86blxbk6l2iklab7y11b734l7yb1bp35dmy27w26";
  };

  propagatedBuildInputs = [ aiohttp ];

  doCheck = pythonOlder "3.11"; # asynctest is unsupported on python3.11

  nativeCheckInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymelcloud" ];

  meta = with lib; {
    description = "Python module for interacting with MELCloud";
    homepage = "https://github.com/vilppuvuorinen/pymelcloud";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
