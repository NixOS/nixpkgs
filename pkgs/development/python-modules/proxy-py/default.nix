{
  lib,
  bash,
  buildPythonPackage,
  fetchFromGitHub,
  gnumake,
  h2,
  hpack,
  httpx,
  hyperframe,
  openssl,
  paramiko,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "proxy-py";
  version = "2.4.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "abhinavsingh";
    repo = "proxy.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-pn4YYGntG9C8mhECb7PYgN5wwicdlPcZu6Xn2M3iIKA=";
  };

  postPatch = ''
    substituteInPlace Makefile \
    --replace "SHELL := /bin/bash" "SHELL := ${bash}/bin/bash"
    substituteInPlace pytest.ini \
      --replace-fail "-p pytest_cov" "" \
      --replace-fail "--no-cov-on-fail" ""
    sed -i "/--cov/d" pytest.ini
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    paramiko
    typing-extensions
  ];

  nativeCheckInputs = [
    gnumake
    h2
    hpack
    httpx
    hyperframe
    openssl
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    requests
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Test requires network access
    "http"
    "http2"
    "proxy"
    "web_server"
    # Location is not writable
    "test_gen_csr"
    # Tests run into a timeout
    "integration"
  ];

  pythonImportsCheck = [ "proxy" ];

  meta = with lib; {
    description = "Python proxy framework";
    homepage = "https://github.com/abhinavsingh/proxy.py";
    changelog = "https://github.com/abhinavsingh/proxy.py/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
