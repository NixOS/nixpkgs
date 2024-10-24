{
  aiohttp,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  multidict,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiohttp-sse-client2";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "compat-fork";
    repo = "aiohttp-sse-client";
    rev = "refs/tags/${version}";
    hash = "sha256-uF39gpOYzNotVVYQShUoiuvYAhSRex2T1NfuhgwSCR4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
    multidict
    yarl
  ];

  pythonImportsCheck = [ "aiohttp_sse_client2" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  # tests access the internet
  doCheck = false;

  meta = {
    changelog = "https://github.com/compat-fork/aiohttp-sse-client/blob/${src.rev}/README.rst#fork-changelog";
    description = "Server-Sent Event python client library based on aiohttp";
    homepage = "https://github.com/compat-fork/aiohttp-sse-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
