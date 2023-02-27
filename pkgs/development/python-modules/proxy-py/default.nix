{ lib
, stdenv
, bash
, buildPythonPackage
, fetchFromGitHub
, gnumake
, httpx
, openssl
, paramiko
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools-scm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "proxy-py";
  version = "2.4.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "abhinavsingh";
    repo = "proxy.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-dA7a9RicBFCSf6IoGX/CdvI8x/xMOFfNtyuvFn9YmHI=";
  };

  postPatch = ''
    substituteInPlace Makefile \
    --replace "SHELL := /bin/bash" "SHELL := ${bash}/bin/bash"
    substituteInPlace pytest.ini \
      --replace "-p pytest_cov" "" \
      --replace "--no-cov-on-fail" ""
    sed -i "/--cov/d" pytest.ini
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    paramiko
    typing-extensions
  ];

  nativeCheckInputs = [
    httpx
    openssl
    gnumake
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Test requires network access
    "test_http2_via_proxy"
    # Tests run into a timeout
    "integration"
  ];

  pythonImportsCheck = [
    "proxy"
  ];

  meta = with lib; {
    description = "Python proxy framework";
    homepage = "https://github.com/abhinavsingh/proxy.py";
    changelog = "https://github.com/abhinavsingh/proxy.py/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
  };
}
