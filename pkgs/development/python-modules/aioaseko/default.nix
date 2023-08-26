{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, setuptools
, pyjwt
}:

buildPythonPackage rec {
  pname = "aioaseko";
  version = "0.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RgIwA5/W7qtgI9ZTF4oDPuzSc+r04ZV3JOaNNFjS0pU=";
  };

  patches = [
    # Remove time, https://github.com/milanmeu/aioaseko/pull/6
    (fetchpatch {
      name = "remove-time.patch";
      url = "https://github.com/milanmeu/aioaseko/commit/07d7ca43a2edd060e95a64737f072d98ba938484.patch";
      hash = "sha256-67QaqSy5mGY/22jWHOkymr0pFoiizVQAXlrqXRb3tG0=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    pyjwt
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioaseko"
  ];

  meta = with lib; {
    description = "Module to interact with the Aseko Pool Live API";
    homepage = "https://github.com/milanmeu/aioaseko";
    changelog = "https://github.com/milanmeu/aioaseko/releases/tag/v${version}";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
