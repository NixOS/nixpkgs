{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, setuptools
, wheel
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

  patches = [
    # https://github.com/home-assistant-libs/pyprusalink/pull/55
    (fetchpatch {
      name = "unpin-setuptools-dependency.patch";
      url = "https://github.com/home-assistant-libs/pyprusalink/commit/8efc3229c491a1763456f0f4017251d5789c6d0a.patch";
      hash = "sha256-kTu1+IwDrcdqelyK/vfhxw8MQBis5I1jag7YTytKQhs=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
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
