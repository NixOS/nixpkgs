{ lib
, async-timeout
, buildPythonPackage
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
, starlette
, trio
, yarl
}:

buildPythonPackage rec {
  pname = "httpx-socks";
  version = "0.7.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HwLJ2pScgiNmM/l14aKp47MMuGW1qSaIq7ujpCSRtqA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'httpcore>=0.14.0,<0.17.0'," "'httpcore>=0.14.0,<0.18.0',"
  '';

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

  nativeCheckInputs = [
    flask
    hypercorn
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    starlette
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
