{ lib
, buildPythonPackage
, fetchFromGitHub
, git
, poetry-core
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
, pytestCheckHook
, faker
, aioresponses
, hypothesis
, pytest-aiohttp
, pytest-benchmark
}:

buildPythonPackage rec {
  pname = "matrix-nio";
  version = "0.18.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    sha256 = "1sjdqzlk8vgv0748ayhnadw1bip3i4bfga4knb94cfkd3s4rgb39";
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
    attrs
    future
    aiohttp
    aiohttp-socks
    aiofiles
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
