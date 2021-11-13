{ lib
, async-timeout
, buildPythonPackage
, curio
, fetchFromGitHub
, fetchpatch
, flask
, httpcore
, httpx
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, python-socks
, pythonOlder
, sniffio
, trio
, yarl
}:

buildPythonPackage rec {
  pname = "httpx-socks";
  version = "0.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cwazage26FkFOf0NObwhdfb35scT3SaX3UJFaoH733g=";
  };

  propagatedBuildInputs = [
    async-timeout
    curio
    httpcore
    httpx
    python-socks
    sniffio
    trio
  ];

  checkInputs = [
    flask
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    yarl
  ];

  patches = [
    # Certificate for tests was expired
    (fetchpatch {
      name = "certificate.patch";
      url = "https://github.com/romis2012/httpx-socks/commit/e12a0522ae667adf93483654206d4c09c3ae48ee.patch";
      sha256 = "1mqykbii0r3by75bd2grppajyd4cbyhc6vp65fh0cgyp1x2gf00c";
    })
  ];

  pythonImportsCheck = [
    "httpx_socks"
  ];

  meta = with lib; {
    description = "Proxy (HTTP, SOCKS) transports for httpx";
    homepage = "https://github.com/romis2012/httpx-socks";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
