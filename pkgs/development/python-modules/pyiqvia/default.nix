{ lib
, buildPythonPackage
, aiohttp
, aresponses
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyiqvia";
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "089lah23939m523jmjkaw2li0fikp2nswxznfvzwnr6wjpp3m9as";
  };

  nativeBuildInputs = [ poetry-core ];

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
