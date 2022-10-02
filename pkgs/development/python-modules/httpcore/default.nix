{ lib
, anyio
, buildPythonPackage
, certifi
, fetchFromGitHub
, h11
, h2
, pproxy
, pytest-asyncio
, pytest-httpbin
, pytest-trio
, pytestCheckHook
, pythonOlder
, sniffio
, socksio
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    hash = "sha256-FF3Yzac9nkVcA5bHVOz2ymvOelSfJ0K6oU8UWpBDcmo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "h11>=0.11,<0.13" "h11>=0.11,<0.14"
  '';

  propagatedBuildInputs = [
    anyio
    certifi
    h11
    sniffio
  ];

  passthru.optional-dependencies = {
    http2 = [
      h2
    ];
    socks = [
      socksio
    ];
  };

  checkInputs = [
    pproxy
    pytest-asyncio
    pytest-httpbin
    pytest-trio
    pytestCheckHook
  ] ++ passthru.optional-dependencies.http2
    ++ passthru.optional-dependencies.socks;

  pythonImportsCheck = [
    "httpcore"
  ];

  pytestFlagsArray = [
    "--asyncio-mode=strict"
  ];

  meta = with lib; {
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
