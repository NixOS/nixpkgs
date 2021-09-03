{ lib
, buildPythonPackage
, pythonOlder
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
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    rev = "v${version}";
    sha256 = "0qvv2697yhqjmgvh37h8wgz3a77n61kqmxvsk4pf47wn43hks15c";
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
