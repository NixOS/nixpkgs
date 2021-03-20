{ lib
, buildPythonPackage
, fetchFromGitHub
, git
, attrs
, future
, aiohttp
, aiohttp-socks
, aiofiles
, h11
, h2
, Logbook
, jsonschema
, unpaddedbase64
, pycryptodome
, python-olm
, peewee
, cachetools
, atomicwrites
, poetry-core
, pytestCheckHook
, faker
, aioresponses
, hypothesis
, pytest-aiohttp
, pytest-benchmark
}:

buildPythonPackage rec {
  pname = "matrix-nio";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    sha256 = "sha256:0fdcbkrki5ni8aaq9xbrmpj1n7hf9z1vvi1b6jkzl55ahc0n50ki";
  };

  format = "pyproject";

  nativeBuildInputs = [
    git
    poetry-core
    pytestCheckHook
  ];

  patches = [ ./update-dependencies.patch ];

  propagatedBuildInputs = [
    attrs
    future
    aiohttp
    aiofiles
    aiohttp-socks
    h11
    h2
    Logbook
    jsonschema
    unpaddedbase64
    pycryptodome
    python-olm
    peewee
    cachetools
    atomicwrites
  ];

  checkInputs = [
    faker
    aioresponses
    hypothesis
    pytest-aiohttp
    pytest-benchmark
  ];

  disabledTests = [
    # touches network
    "test_connect_wrapper"
    # time dependent and flaky
    "test_transfer_monitor_callbacks"
  ];

  meta = with lib; {
    description = "A Python Matrix client library, designed according to sans I/O principles";
    homepage = "https://github.com/poljar/matrix-nio";
    license = licenses.isc;
    maintainers = with maintainers; [ tilpner emily symphorien ];
  };
}
