{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, semver
, asynctest
, deepmerge
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "blebox-uniapi";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-0Yiooy7YSUFjqqcyH2fPQ6AWuR0EJxfRRZTw/6JGcMA=";
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

  pythonImportsCheck = [ "blebox_uniapi" ];

  meta = with lib; {
    description = "Python API for accessing BleBox smart home devices";
    homepage = "https://github.com/blebox/blebox_uniapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
