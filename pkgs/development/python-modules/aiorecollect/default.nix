{ lib
, aiohttp
, aresponses
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
  version = "1.0.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-5+v+TlLOgaIA8svpbgFSEWZAUVBRq3zqf8QbidKgygI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aresponses
    freezegun
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  disabledTestPaths = [ "examples/" ];

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
