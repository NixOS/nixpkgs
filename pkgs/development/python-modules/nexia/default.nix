{ lib
, aioresponses
, buildPythonPackage
, orjson
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, setuptools
}:

buildPythonPackage rec {
  pname = "nexia";
  version = "2.0.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "nexia";
    rev = "refs/tags/${version}";
    hash = "sha256-dWFARVmGGQxyRhaOrDoAjwXTQNKBFHY2/swFVdEOsmo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    orjson
    requests
  ];

  nativeCheckInputs = [
    aioresponses
    requests-mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nexia"
  ];

  meta = with lib; {
    description = "Python module for Nexia thermostats";
    homepage = "https://github.com/bdraco/nexia";
    changelog = "https://github.com/bdraco/nexia/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
