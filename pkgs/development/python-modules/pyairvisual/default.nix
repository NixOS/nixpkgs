{ lib
, aiohttp
, aresponses
, buildPythonPackage
, certifi
, fetchFromGitHub
, fetchpatch
, numpy
, poetry-core
, pygments
, pysmb
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyairvisual";
  version = "2023.08.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+yqN3q+uA/v01uCguzUSoeCJK9lRmiiYn8d272+Dd2M=";
  };

  patches = [
    # https://github.com/bachya/pyairvisual/pull/298
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/pyairvisual/commit/eb32beb7229a53ff81917cc417ed66b26aae47dd.patch";
      hash = "sha256-RLRbHmaR2A8MNc96WHx0L8ccyygoBUaOulAuRJkFuUM=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      'certifi = ">=2023.07.22"' \
      'certifi = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    certifi
    numpy
    pygments
    pysmb
  ];

  # this lets tests bind to localhost in sandbox mode on macOS
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [
    "pyairvisual"
  ];

  meta = with lib; {
    description = "Python library for interacting with AirVisual";
    homepage = "https://github.com/bachya/pyairvisual";
    changelog = "https://github.com/bachya/pyairvisual/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
