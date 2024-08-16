{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiofiles,
  aiohttp,
  aiohttp-socks,
  h11,
  h2,
  jsonschema,
  pycryptodome,
  unpaddedbase64,

  # optional-dependencies
  atomicwrites,
  cachetools,
  peewee,
  python-olm,

  # tests
  aioresponses,
  faker,
  hpack,
  hyperframe,
  hypothesis,
  pytest-aiohttp,
  pytest-benchmark,
  pytestCheckHook,

  # passthru tests
  nixosTests,
  opsdroid,
  pantalaimon,
  weechatScripts,
  zulip,
}:

buildPythonPackage rec {
  pname = "matrix-nio";
  version = "0.24.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    hash = "sha256-XlswVHLvKOi1qr+I7Mbm4IBjn1DG7glgDsNY48NA5Ew=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    aiohttp-socks
    h11
    h2
    jsonschema
    pycryptodome
    unpaddedbase64
  ];

  passthru.optional-dependencies = {
    e2e = [
      atomicwrites
      cachetools
      python-olm
      peewee
    ];
  };

  nativeCheckInputs = [
    aioresponses
    faker
    hpack
    hyperframe
    hypothesis
    pytest-aiohttp
    pytest-benchmark
    pytestCheckHook
  ] ++ passthru.optional-dependencies.e2e;

  pytestFlagsArray = [ "--benchmark-disable" ];

  disabledTests = [
    # touches network
    "test_connect_wrapper"
    # time dependent and flaky
    "test_transfer_monitor_callbacks"
  ];

  passthru.tests = {
    inherit (nixosTests)
      dendrite
      matrix-appservice-irc
      matrix-conduit
      mjolnir
      ;
    inherit (weechatScripts) weechat-matrix;
    inherit opsdroid pantalaimon zulip;
  };

  meta = with lib; {
    homepage = "https://github.com/poljar/matrix-nio";
    changelog = "https://github.com/poljar/matrix-nio/blob/${version}/CHANGELOG.md";
    description = "Python Matrix client library, designed according to sans I/O principles";
    license = licenses.isc;
    maintainers = with maintainers; [
      tilpner
      symphorien
    ];
  };
}
