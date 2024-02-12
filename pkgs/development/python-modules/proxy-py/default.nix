{ lib
, stdenv
, bash
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
, wheel
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

  patches = [
    # this patch is so that the one following it applies cleanly
    # https://github.com/abhinavsingh/proxy.py/pull/1209
    (fetchpatch {
      name = "update-build-dependencies.patch";
      url = "https://github.com/abhinavsingh/proxy.py/commit/2e535360ce5ed9734f2c00dc6aefe5ebd281cea5.patch";
      hash = "sha256-eR3R4M7jwQMnY5ob0V6G71jXcrkV7YZvo1JOUG4gnrY=";
    })
    # https://github.com/abhinavsingh/proxy.py/pull/1345
    (fetchpatch {
      name = "remove-setuptools-scm-git-archive-dependency.patch";
      url = "https://github.com/abhinavsingh/proxy.py/commit/027bfa6b912745f588d272f1a1082f6ca416f815.patch";
      hash = "sha256-O2LlSrSrB3u2McAZRY+KviuU7Hv1tOuf0n+D/H4BWvI=";
    })
  ];

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
    wheel
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
