{ lib
, async-timeout
, buildPythonPackage
, curio
, fetchFromGitHub
, flask
, httpcore
, httpx
, hypercorn
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, python-socks
, pythonOlder
<<<<<<< HEAD
, setuptools
, sniffio
, starlette
, tiny-proxy
, trio
, trustme
=======
, sniffio
, starlette
, trio
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, yarl
}:

buildPythonPackage rec {
  pname = "httpx-socks";
<<<<<<< HEAD
  version = "0.7.6";
  format = "pyproject";
=======
  version = "0.7.5";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-rLcYC8IO2eCWAL4QIiUg/kyigybq6VNTUjNDXx4KPHc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
    hash = "sha256-HwLJ2pScgiNmM/l14aKp47MMuGW1qSaIq7ujpCSRtqA=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    httpx
    httpcore
    python-socks
  ];

  passthru.optional-dependencies = {
    asyncio = [
      async-timeout
    ];
    trio = [
      trio
    ];
  };

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    flask
    hypercorn
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    starlette
<<<<<<< HEAD
    tiny-proxy
    trustme
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    yarl
  ];

  pythonImportsCheck = [
    "httpx_socks"
  ];

  disabledTests = [
    # Tests don't work in the sandbox
    "test_proxy"
    "test_secure_proxy"
  ];

  meta = with lib; {
    description = "Proxy (HTTP, SOCKS) transports for httpx";
    homepage = "https://github.com/romis2012/httpx-socks";
    changelog = "https://github.com/romis2012/httpx-socks/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
