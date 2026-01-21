{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aioquic,
  cacert,
  h11,
  h2,
  httpx,
  priority,
  trio,
  uvloop,
  wsproto,
  poetry-core,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hypercorn";
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.11"; # missing taskgroup dependency

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "Hypercorn";
    tag = version;
    hash = "sha256-RNurpDq5Z3N9Wv9Hq/l6A3yKUriCCKx9BrbrWGwBsUk=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [
    h11
    h2
    priority
    wsproto
  ];

  optional-dependencies = {
    h3 = [ aioquic ];
    trio = [ trio ];
    uvloop = [ uvloop ];
  };

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytest-trio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "hypercorn" ];

  meta = {
    changelog = "https://github.com/pgjones/hypercorn/blob/${src.tag}/CHANGELOG.rst";
    homepage = "https://github.com/pgjones/hypercorn";
    description = "ASGI web server inspired by Gunicorn";
    mainProgram = "hypercorn";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dgliwka ];
  };
}
