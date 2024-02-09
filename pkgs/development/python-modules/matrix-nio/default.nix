{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, logbook
, aiofiles
, aiohttp
, aiohttp-socks
, aioresponses
, atomicwrites
, attrs
, cachetools
, faker
, future
, git
, h11
, h2
, hypothesis
, jsonschema
, peewee
, poetry-core
, py
, pycryptodome
, pytest-aiohttp
, pytest-benchmark
, pytestCheckHook
, python-olm
, unpaddedbase64
}:

buildPythonPackage rec {
  pname = "matrix-nio";
  version = "0.22.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    hash = "sha256-hFSS2Nys95YJgBNED8SBan24iRo2q/UOr6pqUPAF5Ms=";
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
    git
    poetry-core
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    aiohttp-socks
    attrs
    future
    h11
    h2
    jsonschema
    logbook
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
    hypothesis
    py
    pytest-aiohttp
    pytest-benchmark
    pytestCheckHook
  ] ++ passthru.optional-dependencies.e2e;

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  disabledTests = [
    # touches network
    "test_connect_wrapper"
    # time dependent and flaky
    "test_transfer_monitor_callbacks"
  ];

  meta = with lib; {
    homepage = "https://github.com/poljar/matrix-nio";
    changelog = "https://github.com/poljar/matrix-nio/blob/${version}/CHANGELOG.md";
    description = "A Python Matrix client library, designed according to sans I/O principles";
    license = licenses.isc;
    maintainers = with maintainers; [ tilpner emily symphorien ];
  };
}
