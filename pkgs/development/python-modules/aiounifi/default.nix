{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, orjson
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, segno
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aiounifi";
<<<<<<< HEAD
  version = "62";
  format = "pyproject";

  disabled = pythonOlder "3.11";
=======
  version = "47";
  format = "setuptools";

  disabled = pythonOlder "3.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-5XCF67YuelS4RDUxfImSAELfdb3rJWGprIYQeQPp+yk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools==" "setuptools>=" \
      --replace "wheel==" "wheel>="

    sed -i '/--cov=/d' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    orjson
    segno
=======
    hash = "sha256-/BdSB7CD/ob8vinYDZVy0FNU23PSCiHF8jHGQUDsm1w=";
  };

  propagatedBuildInputs = [
    aiohttp
    orjson
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [
    "aiounifi"
  ];

  meta = with lib; {
    description = "Python library for communicating with Unifi Controller API";
    homepage = "https://github.com/Kane610/aiounifi";
    changelog = "https://github.com/Kane610/aiounifi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
