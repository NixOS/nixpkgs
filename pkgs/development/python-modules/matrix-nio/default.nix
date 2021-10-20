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
, pycryptodome
, pytest-aiohttp
, pytest-benchmark
, pytestCheckHook
, python-olm
, unpaddedbase64
}:

buildPythonPackage rec {
  pname = "matrix-nio";
  version = "0.18.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    hash = "sha256-eti9kvfv3y7m+mJzcxftyn8OyVSd2Ehqd3eU2ezMV5Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'aiofiles = "^0.6.0"' 'aiofiles = "*"'
  '';

  nativeBuildInputs = [
    git
    poetry-core
    pytestCheckHook
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

  checkInputs = [
    aioresponses
    faker
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
    homepage = "https://github.com/poljar/matrix-nio";
    description = "A Python Matrix client library, designed according to sans I/O principles";
    license = licenses.isc;
    maintainers = with maintainers; [ tilpner emily symphorien ];
  };
}
