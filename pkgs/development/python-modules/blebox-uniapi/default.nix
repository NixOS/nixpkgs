{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, semver
, asynctest
, deepmerge
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "blebox-uniapi";
  version = "2.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-rgZ/nHihhPZnc8LLtsrAXDCQT1XaXOnI7xBid+6khfs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    aiohttp
    semver
  ];

  checkInputs = [
    asynctest
    deepmerge
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "blebox_uniapi"
  ];

  meta = with lib; {
    description = "Python API for accessing BleBox smart home devices";
    homepage = "https://github.com/blebox/blebox_uniapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
