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
<<<<<<< HEAD
# for passthru.tests
, httpx
, httpx-socks
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "httpcore";
<<<<<<< HEAD
  version = "0.17.2";
=======
  version = "0.16.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-qAoORhzBbjXxgtzTqbAxWBxrohzfwDWm5mxxrgeXt48=";
=======
    hash = "sha256-3bC97CTZi6An+owjoJF7Irtr7ONbP8RtNdTIGJRy0Ng=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

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

  nativeCheckInputs = [
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

  preCheck = ''
    # remove upstreams pytest flags which cause:
    # httpcore.ConnectError: TLS/SSL connection has been closed (EOF) (_ssl.c:997)
    rm setup.cfg
  '';

  pytestFlagsArray = [
    "--asyncio-mode=strict"
  ];

  __darwinAllowLocalNetworking = true;

<<<<<<< HEAD
  passthru.tests = {
    inherit httpx httpx-socks;
  };

  meta = with lib; {
    changelog = "https://github.com/encode/httpcore/releases/tag/${version}";
=======
  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
