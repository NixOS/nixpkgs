{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  aioquic,
  h11,
  h2,
  httpx,
  priority,
  trio,
  uvloop,
  wsproto,
  pdm-backend,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hypercorn";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "Hypercorn";
    tag = version;
    hash = "sha256-RNurpDq5Z3N9Wv9Hq/l6A3yKUriCCKx9BrbrWGwBsUk=";
  };

  patches = [
    # add :protocol pseudo-header for Extended CONNECT, https://github.com/pgjones/hypercorn/pull/371
    (fetchpatch2 {
      name = "add-header.patch";
      url = "https://github.com/pgjones/hypercorn/commit/9c1f350e2637cfa0287aad2ae9a5bfd003a1d248.patch";
      hash = "sha256-vHCed1mU/ajHkBVH7IZ8kfuEZQyQi++UL4xhBr6LePk=";
    })
  ];

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  build-system = [ pdm-backend ];

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

  disabledTests = [
    "test_http2_websocket"
  ];

  meta = {
    description = "ASGI web server inspired by Gunicorn";
    homepage = "https://github.com/pgjones/hypercorn";
    changelog = "https://github.com/pgjones/hypercorn/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dgliwka ];
    mainProgram = "hypercorn";
  };
}
