{ lib
, buildPythonPackage
, fetchFromGitHub
, Logbook
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
  version = "0.20.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    hash = "sha256-6oMOfyl8yR8FMprPYD831eiXh9g/bqslvxDmVcrNK80=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'aiofiles = "^0.6.0"' 'aiofiles = "*"' \
      --replace 'h11 = "^0.12.0"' 'h11 = "*"' \
      --replace 'jsonschema = "^3.2.0"' 'jsonschema = "*"' \
      --replace 'cachetools = { version = "^4.2.1", optional = true }' 'cachetools = { version = "*", optional = true }'
  '';

  nativeBuildInputs = [
    git
    poetry-core
  ];

  propagatedBuildInputs = [
    Logbook
    aiofiles
    aiohttp
    aiohttp-socks
    atomicwrites
    attrs
    cachetools
    future
    h11
    h2
    jsonschema
    peewee
    pycryptodome
    python-olm
    unpaddedbase64
  ];

  nativeCheckInputs = [
    aioresponses
    faker
    hypothesis
    py
    pytest-aiohttp
    pytest-benchmark
    pytestCheckHook
  ];

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
    description = "A Python Matrix client library, designed according to sans I/O principles";
    license = licenses.isc;
    maintainers = with maintainers; [ tilpner emily symphorien ];
  };
}
