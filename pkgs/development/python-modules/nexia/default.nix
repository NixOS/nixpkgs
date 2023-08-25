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
}:

buildPythonPackage rec {
  pname = "nexia";
  version = "2.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1uCmlFkha5oaNm5N0/8402ulBr7fNRUbDDASECfN9r8=";
  };

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

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  pythonImportsCheck = [
    "nexia"
  ];

  meta = with lib; {
    description = "Python module for Nexia thermostats";
    homepage = "https://github.com/bdraco/nexia";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
