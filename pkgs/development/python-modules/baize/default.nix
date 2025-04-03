{
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  pdm-pep517,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  starlette,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "baize";
  version = "0.22.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abersheeran";
    repo = "baize";
    tag = "v${version}";
    hash = "sha256-vsYt1q8QEDmEXjd8dlzHr85Fz3YAjPowS+oBWYGbG1o=";
  };

  patches = [
    # Fix tests failing with httpx>=0.28
    # https://github.com/abersheeran/baize/pull/74
    # FIXME: Remove in next release
    (fetchpatch {
      url = "https://github.com/abersheeran/baize/commit/40dc83bc03b4e5acd5155917be3a481e6494530e.patch";
      hash = "sha256-z4jb4iwo51WIPAAECiM4kPThpHcrzy3349gm/orgoq8=";
    })
  ];

  build-system = [
    pdm-pep517
    setuptools
  ];

  pythonImportsCheck = [ "baize" ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
    starlette
  ];

  disabledTests = [
    # test relies on last modified date, which is set to 1970-01-01 in the sandbox
    "test_files"
    # starlette.testclient.WebSocketDenialResponse
    "test_request_response"
  ];

  meta = {
    description = "Powerful and exquisite WSGI/ASGI framework/toolkit";
    homepage = "https://github.com/abersheeran/baize";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dotlambda
      bot-wxt1221
    ];
  };
}
