{ lib
, buildPythonPackage
, aiohttp
, aresponses
, fetchFromGitHub
, poetry
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyiqvia";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "1yjsbq4p040a35n8g2l0wgnv83wkjirv4rj73s2mjzn3cxf395bz";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  # Ignore the examples as they are prefixed with test_
  pytestFlagsArray = [ "--ignore examples/" ];
  pythonImportsCheck = [ "pyiqvia" ];

  meta = with lib; {
    description = "Python3 API for IQVIA data";
    longDescription = ''
      pyiqvia is an async-focused Python library for allergen, asthma, and
      disease data from the IQVIA family of websites (such as https://pollen.com,
      https://flustar.com and more).
    '';
    homepage = "https://github.com/bachya/pyiqvia";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
