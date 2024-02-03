{ lib
, buildPythonPackage
, fetchFromGitHub
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
