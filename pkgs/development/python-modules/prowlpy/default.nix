{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  httpx,
  lib,
  loguru,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  respx,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "prowlpy";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OMEGARAZER";
    repo = "prowlpy";
    tag = "v${version}";
    hash = "sha256-vtLj0Rxl8XM6JigM5kWQWiEaE8dDQ40zsZGRPfJ+aiY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    xmltodict
  ]
  ++ httpx.optional-dependencies.http2;

  optional-dependencies = {
    cli = [
      click
      loguru
    ];
  };

  pythonImportsCheck = [ "prowlpy" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    respx
  ]
  ++ lib.concatAttrValues optional-dependencies;

  # tests fail without this
  pytestFlags = [ "-v" ];

  meta = {
    changelog = "https://github.com/OMEGARAZER/prowlpy/blob/${src.tag}/CHANGELOG.md";
    description = "Send push notifications to iPhones using the Prowl API";
    homepage = "https://github.com/OMEGARAZER/prowlpy";
    license = lib.licenses.gpl3Only;
    mainProgram = "prowlpy";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
