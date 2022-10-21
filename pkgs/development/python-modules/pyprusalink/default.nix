{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pyprusalink";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-XRtbb7kceiqi8pioTWStRo0drCtQfy1t62jCMihlIec=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "pyprusalink"
  ];

  meta = with lib; {
    description = "Library to communicate with PrusaLink ";
    homepage = "https://github.com/home-assistant-libs/pyprusalink";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
