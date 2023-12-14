{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiodns
, aiohttp
, awesomeversion
, backoff
, cachetools
, mashumaro
, orjson
, pycountry
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "radios";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.11";


  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-radios";
    rev = "v${version}";
    hash = "sha256-bzo+SA8kqc2GcxSV0TiIJyPVG+JshdsMoXSUhZYSphU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiodns
    aiohttp
    awesomeversion
    backoff
    cachetools
    mashumaro
    orjson
    pycountry
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "radios" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Asynchronous Python client for the Radio Browser API";
    homepage = "https://github.com/frenck/python-radios";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
