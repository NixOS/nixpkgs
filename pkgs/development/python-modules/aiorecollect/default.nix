{ lib
, aiohttp
, aresponses
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, freezegun
, poetry-core
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiorecollect";
  version = "1.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "0dlz8zmqcn6g6000lfgcy5krpfafzdzrznmk6iwra65wcs7l9392";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    aresponses
    freezegun
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  # Ignore the examples as they are prefixed with test_
  pytestFlagsArray = [ "--ignore examples/" ];
  pythonImportsCheck = [ "aiorecollect" ];

  meta = with lib; {
    description = "Python library for the Recollect Waste API";
    longDescription = ''
      aiorecollect is a Python asyncio-based library for the ReCollect
      Waste API. It allows users to programmatically retrieve schedules
      for waste removal in their area, including trash, recycling, compost
      and more.
    '';
    homepage = "https://github.com/bachya/aiorecollect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
