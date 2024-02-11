{ lib
, buildPythonPackage
, aiohttp
, async-timeout
, chacha20poly1305-reuseable
, cryptography
, deepdiff
, fetchFromGitHub
, ifaddr
, mediafile
, miniaudio
, protobuf
, pydantic
, pyfakefs
, pytest-aiohttp
, pytest-asyncio
, pytest-httpserver
, pytest-timeout
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, requests
, setuptools
, srptools
, stdenv
, tabulate
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.14.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = "pyatv";
    rev = "refs/tags/v${version}";
    hash = "sha256-Uykj9MIUFcZyTWOBjUhL9+qItbnpwtuTd2Cx5jI7Wtw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  pythonRelaxDeps = [
    "aiohttp"
    "async_timeout"
    "bitarray"
    "chacha20poly1305-reuseable"
    "cryptography"
    "ifaddr"
    "mediafile"
    "miniaudio"
    "protobuf"
    "requests"
    "srptools"
    "zeroconf"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    chacha20poly1305-reuseable
    cryptography
    ifaddr
    mediafile
    miniaudio
    protobuf
    pydantic
    requests
    srptools
    tabulate
    zeroconf
  ];

  nativeCheckInputs = [
    deepdiff
    pyfakefs
    pytest-aiohttp
    pytest-asyncio
    pytest-httpserver
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/postlund/pyatv/issues/2307
    "test_zeroconf_service_published"
  ] ++ lib.optionals (stdenv.isDarwin) [
    # tests/protocols/raop/test_raop_functional.py::test_stream_retransmission[raop_properties2-2-True] - assert False
    "test_stream_retransmission"
  ];

  disabledTestPaths = [
    # Test doesn't work in the sandbox
    "tests/protocols/companion/test_companion_auth.py"
    "tests/protocols/mrp/test_mrp_auth.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "pyatv"
  ];

  meta = with lib; {
    description = "Python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    changelog = "https://github.com/postlund/pyatv/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
