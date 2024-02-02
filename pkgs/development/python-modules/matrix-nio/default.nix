{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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

  patches = [
    # Those two patches makes `matrix-nio` more compatible with alternative
    # Matrix homeservers like conduit.rs. They are critical for… well using this library…
    # https://github.com/matrix-nio/matrix-nio/pull/483
    (fetchpatch {
      url = "https://github.com/matrix-nio/matrix-nio/commit/5c1a393fa16d5310e458539d64c25e0c2034a025.patch";
      hash = "sha256-C39eufMI/HITnElEBpj0jBUIn3m0/XxXdxRdz1fhXhs=";
    })
    # https://github.com/matrix-nio/matrix-nio/pull/482
    (fetchpatch {
      url = "https://github.com/matrix-nio/matrix-nio/pull/482/commits/64c646edb918fe7ef57a6f9d76d95c24d3c41c07.patch";
      hash = "sha256-SllZV+gBMjqfX9BUD1OrmZpy617c2FO110As9hw5mS0=;";
    })
    # https://github.com/matrix-nio/matrix-nio/pull/486
    (fetchpatch {
      url = "https://github.com/matrix-nio/matrix-nio/pull/486/commits/7826f7a1fa2bf55fd4ae32292550237a3dd65ef7.patch";
      hash = "sha256-vT12I+DOyNLZrkG7LzlgWFminEfKfrQDZ6Fokz1gUsE=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'aiofiles = "^0.6.0"' 'aiofiles = "*"' \
      --replace 'h11 = "^0.12.0"' 'h11 = "*"' \
      --replace 'cachetools = { version = "^4.2.1", optional = true }' 'cachetools = { version = "*", optional = true }' \
      --replace 'aiohttp-socks = "^0.7.0"' 'aiohttp-socks = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

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
    description = "A Python Matrix client library, designed according to sans I/O principles";
    license = licenses.isc;
    maintainers = with maintainers; [
      tilpner
      emily
      symphorien
    ];
  };
}
